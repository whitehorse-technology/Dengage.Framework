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
        
        let returnValue = storage.getValueWithKey(key: "ApplicationIdentifier")
        
        if returnValue == nil {
            
            logger.Log(message: "GENERATING_NSUUID", logtype: .info)
            appIdentifier = NSUUID().uuidString.lowercased()
            storage.setValueWithKey(value: appIdentifier, key: "ApplicationIdentifier")
            
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
