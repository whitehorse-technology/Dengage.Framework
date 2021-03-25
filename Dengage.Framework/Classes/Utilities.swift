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
    class func color(hex hexString: String?) -> UIColor? {
        guard let hex = hexString else {return nil}
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        var rgba = hex
        if !rgba.hasPrefix("#") {
            rgba = "#" + rgba
        }

        let suffixCount = rgba.count - 1
        let hexrgba = String(rgba.suffix(suffixCount))
        let scanner = Scanner(string: hexrgba)
        var hexValue: CUnsignedLongLong = 0

        if scanner.scanHexInt64(&hexValue) {
            switch hexrgba.count {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue  = CGFloat(hexValue & 0x00F) / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                alpha = CGFloat(hexValue & 0x000F) / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue  = CGFloat(hexValue & 0x0000FF) / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            default: break
            }
        } else {
           return nil
        }

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
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

extension Dictionary {
    var json: Data? {
        try? JSONSerialization.data(withJSONObject: self)
    }
}
