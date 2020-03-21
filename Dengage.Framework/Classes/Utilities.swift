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
    
    static let shared   = Utilities()
    var _storage  : DengageLocalStorage
    var _logger   : SDKLogger
    var _asIdentifierManager : ASIdentifierManager
    var _ctTelephonyNetworkInfo : CTTelephonyNetworkInfo
    
    init() {
        _storage = DengageLocalStorage.shared
        _logger = SDKLogger.shared
        _asIdentifierManager = ASIdentifierManager.shared()
        _ctTelephonyNetworkInfo = CTTelephonyNetworkInfo()
    }

    init(storage: DengageLocalStorage = .shared,
         logger: SDKLogger = .shared,
         asIdentifierManager : ASIdentifierManager = .shared(),
         ctTelephonyNetworkInfo : CTTelephonyNetworkInfo = .init()){
        
        _logger = logger
        _storage = storage
        _asIdentifierManager = asIdentifierManager
        _ctTelephonyNetworkInfo = ctTelephonyNetworkInfo
    }
    
    func identifierForApplication() -> String{
        
        var appIdentifier = ""
        
        let returnValue = _storage.getValueWithKey(key: "ApplicationIdentifier")
        
        if returnValue == nil {
            
            _logger.Log(message:"GENERATING_NSUUID", logtype: .info)
            appIdentifier = NSUUID().uuidString.lowercased()
            _storage.setValueWithKey(value: appIdentifier, key: "ApplicationIdentifier")
            
        }
        else{
            appIdentifier = returnValue!
        }
        
        _logger.Log(message:"APP_IDENTIFIER is %s " , logtype: .debug, argument: appIdentifier)
        
        return appIdentifier
    }

    func identifierForCarrier() -> String{
        var carrierId = DEFAULT_CARRIER_ID
        
        let carrier = _ctTelephonyNetworkInfo.subscriberCellularProvider
        
        _logger.Log(message: "READ_CARRIER_INFO" , logtype: .debug)
        
        if((carrier?.mobileCountryCode != nil))
        {
            carrierId = carrier?.mobileCountryCode ?? carrierId
        }
        
        if((carrier?.mobileNetworkCode != nil))
        {
            carrierId += carrier?.mobileNetworkCode ?? carrierId
        }
        
        _logger.Log(message: "CARRIER_ID is %s" , logtype: .debug, argument: carrierId)
        
        return carrierId
        
    }
    
    func identifierForAdvertising() -> String {
        // check if advertising tracking is enabled in user’s setting
        var advertisingId = ""
        
    
        if _asIdentifierManager.isAdvertisingTrackingEnabled {
            advertisingId = _asIdentifierManager.advertisingIdentifier.uuidString.lowercased()
        }
        
        _logger.Log(message: "ADVERTISING_ID is %s" , logtype: .debug,  argument:  advertisingId)
        return advertisingId
    }
    
    func indentifierForCFBundleShortVersionString() -> String {
        
        let cfBundleShortVersionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        _logger.Log(message: "VERSION is %s" , logtype: .debug,  argument:  cfBundleShortVersionString)
        return cfBundleShortVersionString
    }
}

extension TimeZone {

    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }

    func offsetInHours() -> String
    {

        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}
