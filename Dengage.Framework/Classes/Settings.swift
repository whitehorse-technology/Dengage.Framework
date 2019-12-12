//
//  Settings.swift
//  self.ios.sdk
//
//  Created by Ekin Bulut on 27.11.2019.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

internal class Settings : NSObject {
    
    static let shared = Settings()
    
    override init() {
        _sdkVersion = SDK_VERSION
        _permission = false
        _badgeCountReset = true
    }
    
    let storage = DengageLocalStorage.shared
    let logger = SDKLogger.shared
    
    private var _integrationKey :   String = ""
    private var _token :            String? = ""
    private var _carrierId :        String = ""
    private var _sdkVersion :       String
    private var _advertisingId :    String = ""
    private var _applicationIdentifier : String = ""
    private var _contactKey :       String = ""
    private var _appVersion :       String = ""
    
    private var _badgeCountReset :  Bool?
    private var _permission :       Bool?;
    
    
    func setSdkVersion(sdkVersion: String){
        
        self._sdkVersion = sdkVersion
    }
    
    func getSdkVersion() -> String {
        
        return self._sdkVersion
    }
    
    func setCarrierId(carrierId: String){
        
        self._carrierId = carrierId;
    }
    
    func getCarrierId() -> String {
        
        return self._carrierId
    }
    
    func setAdvertisingId(advertisingId :String){
        
        self._advertisingId = advertisingId
    }
    
    func getAdvertisinId() -> String? {
        
        return self._advertisingId
    }
    
    func setApplicationIdentifier(applicationIndentifier:String){
        
        self._applicationIdentifier = applicationIndentifier
    }
    
    func getApplicationIdentifier() -> String {
        
        return _applicationIdentifier;
    }
    
    func setDengageIntegrationKey(integrationKey: String){
        
        self._integrationKey = integrationKey
    }
    
    func getDengageIntegrationKey() -> String {
        
        return self._integrationKey
    }
    
    func  setBadgeCountReset(badgeCountReset : Bool?) {
        
        self._badgeCountReset = badgeCountReset
    }
    
    func getBadgeCountReset() -> Bool? {
        
        return self._badgeCountReset
    }
    
    func setContactKey(contactKey : String?){
        
        self._contactKey = contactKey ?? ""
        storage.setValueWithKey(value: contactKey ?? "", key: "ContactKey")
        self._contactKey = storage.getValueWithKey(key: "ContactKey") ?? ""
    }
    
    func getContactKey() -> String? {
        
        self._contactKey = storage.getValueWithKey(key: "ContactKey") ?? ""
        logger.Log(message: "CONTACT_KEY is %s", logtype: .debug, argument: self._contactKey)
        return self._contactKey
    }
    
    func setToken(token: String){
        
        self._token = token
        storage.setValueWithKey(value: token, key: "Token")
        logger.Log(message:"TOKEN %s",  logtype: .debug, argument: self._token!)
        
    }
    
    func getToken() -> String?{
        
        self._token = storage.getValueWithKey(key: "Token")
        return self._token
    }
    
    func setAppVersion(appVersion: String){
        
        self._appVersion = appVersion
    }
    
    func getAppversion() -> String? {
        
        return self._appVersion
    }
    
    
    func setPermission(permission: Bool?){
        
        self._permission = permission
    }
    
    func getPermission() -> Bool? {
        
        return self._permission
    }
}
