//
//  Utilities.swift
//  dengage.ios.sdk
//
//  Created by Developer on 26.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import CoreTelephony
import AdSupport

internal class Utilities {

    static let shared = Utilities()
    var storage: DengageLocalStorage
    var logger: SDKLogger
    var asIdentifierManager: ASIdentifierManager
    var ctTelephonyNetworkInfo: CTTelephonyNetworkInfo
    
    init() {
        storage = DengageLocalStorage.shared
        logger = SDKLogger.shared
        asIdentifierManager = ASIdentifierManager.shared()
        ctTelephonyNetworkInfo = CTTelephonyNetworkInfo()
    }
    
    init(storage: DengageLocalStorage = .shared,
         logger: SDKLogger = .shared,
         asIdentifierManager: ASIdentifierManager = .shared(),
         ctTelephonyNetworkInfo: CTTelephonyNetworkInfo = .init()) {
        
        self.logger = logger
        self.storage = storage
        self.asIdentifierManager = asIdentifierManager
        self.ctTelephonyNetworkInfo = ctTelephonyNetworkInfo
    }
    
    func identifierForApplication() -> String {
        
        var appIdentifier = ""
        
        let returnValue = storage.getValue(key: .applicationIdentifier)
        
        if returnValue == nil {
            
            logger.Log(message: "GENERATING_NSUUID", logtype: .info)
            appIdentifier = NSUUID().uuidString.lowercased()
            storage.set(value: appIdentifier, for: .applicationIdentifier)
            
        } else {
            appIdentifier = returnValue!
        }
        
        logger.Log(message: "APP_IDENTIFIER is %s ", logtype: .debug, argument: appIdentifier)
        
        return appIdentifier
    }
    
    func identifierForCarrier() -> String {
        var carrierId = DEFAULT_CARRIER_ID
        
        let carrier = ctTelephonyNetworkInfo.subscriberCellularProvider
        
        logger.Log(message: "READ_CARRIER_INFO", logtype: .debug)
        
        if carrier?.mobileCountryCode != nil {
            carrierId = carrier?.mobileCountryCode ?? carrierId
        }
        
        if carrier?.mobileNetworkCode != nil {
            carrierId += carrier?.mobileNetworkCode ?? carrierId
        }
        
        logger.Log(message: "CARRIER_ID is %s", logtype: .debug, argument: carrierId)
        
        return carrierId
        
    }
    
    func identifierForAdvertising() -> String {
        // check if advertising tracking is enabled in user’s setting
        var advertisingId = asIdentifierManager.advertisingIdentifier.uuidString.lowercased()
        
        if #available(iOS 14, *) {
            if advertisingId.elementsEqual("00000000-0000-0000-0000-000000000000") == true{
                advertisingId = ""
            }
        } else {
            if asIdentifierManager.isAdvertisingTrackingEnabled {
                advertisingId = asIdentifierManager.advertisingIdentifier.uuidString.lowercased()
            } else {
                advertisingId = ""
            }
        }
        
        logger.Log(message: "ADVERTISING_ID is %s", logtype: .debug, argument: advertisingId)
        return advertisingId
    }
    
    func indentifierForCFBundleShortVersionString() -> String {
        
        let cfBundleShortVersionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0"
        
        logger.Log(message: "VERSION is %s" , logtype: .debug, argument: cfBundleShortVersionString)
        return cfBundleShortVersionString
    }
    
    func generateUUID() -> String {
        return NSUUID().uuidString.lowercased()
    }
    
    static func convertDate(to date: String?) -> Date? {
        guard let dateString = date else {return nil}
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: dateString)
    }
}

extension TimeZone {
    
    func offsetFromUTC() -> String {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
    func offsetInHours() -> String {
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let link = link else {return}
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension UIColor {
    public convenience init?(hex: String?) {
        guard let hex = hex else {return nil}
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
