//
//  Settings.swift
//  self.ios.sdk
//
//  Created by Ekin Bulut on 27.11.2019.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

internal class Settings {
    
    static let shared = Settings()
    
    let storage: DengageLocalStorage
    let logger: SDKLogger
    
    //    MARK:- Variables
    var _integrationKey: String = ""
    var _token: String? = ""
    var _carrierId: String = ""
    var _sdkVersion: String
    var _advertisingId: String = ""
    var _applicationIdentifier : String = ""
    var _contactKey: String = ""
    var _appVersion: String = ""
    var _sessionId: String = ""
    var _referrer: String = ""
    
    var _testGroup: String = ""
    
    var _badgeCountReset: Bool?
    var _permission: Bool?
    var _sessionStarted: Bool
    
    var _useCloudForSubscription: Bool = false
    var _registerForRemoteNotification: Bool = true
    
    init() {
        _sdkVersion = SDK_VERSION
        _permission = false
        _badgeCountReset = true
        storage = DengageLocalStorage.shared
        logger = SDKLogger.shared
        _sessionStarted = false
        
    }
    
    init(storage:  DengageLocalStorage = .shared, logger: SDKLogger = .shared){
        
        self.storage = storage
        self.logger = logger
        _sdkVersion = SDK_VERSION
        _permission = false
        _badgeCountReset = true
        _sessionStarted = false
    }
    
    
    // MARK: -  functions
    func setRegiterForRemoteNotification(enable: Bool)
    {
        self._registerForRemoteNotification = enable
    }
    
    func getRegiterForRemoteNotification() -> Bool {
        
        return self._registerForRemoteNotification
    }
    
    func setCloudEnabled(status: Bool) {
        self._useCloudForSubscription = status
    }
    
    func getCloudEnabled() -> Bool {
        
        return self._useCloudForSubscription
    }
    
    func setTestGroup(testGroup: String) {
        
        _testGroup = testGroup
    }
    
    func getTestGroup() -> String {
        
        return _testGroup
    }
    
    func setSessionStart(status: Bool) {
        self._sessionStarted = status
    }
    
    func getSessionStart() -> Bool {
        
        return self._sessionStarted
    }
    
    func setSessionId(sessionId: String) {
        
        self._sessionId = sessionId
    }
    
    func getSessionId() -> String {
        
        return  self._sessionId
    }
    
    
    func setSdkVersion(sdkVersion: String) {
        
        self._sdkVersion = sdkVersion
    }
    
    func getSdkVersion() -> String {
        
        return self._sdkVersion
    }
    
    func setCarrierId(carrierId: String) {
        
        self._carrierId = carrierId;
    }
    
    func getCarrierId() -> String {
        
        return self._carrierId
    }
    
    func setAdvertisingId(advertisingId:String) {
        
        self._advertisingId = advertisingId
    }
    
    func getAdvertisinId() -> String? {
        
        return self._advertisingId
    }
    
    func setApplicationIdentifier(applicationIndentifier: String) {
        
        self._applicationIdentifier = applicationIndentifier
    }
    
    func getApplicationIdentifier() -> String {
        
        return _applicationIdentifier;
    }
    
    func setDengageIntegrationKey(integrationKey: String) {
        
        self._integrationKey = integrationKey
    }
    
    func getDengageIntegrationKey() -> String {
        
        return self._integrationKey
    }
    
    func  setBadgeCountReset(badgeCountReset: Bool?) {
        
        self._badgeCountReset = badgeCountReset
    }
    
    func getBadgeCountReset() -> Bool? {
        
        return self._badgeCountReset
    }
    
    func setContactKey(contactKey: String?) {
        
        self._contactKey = contactKey ?? ""
        storage.setValueWithKey(value: contactKey ?? "", key: "ContactKey")
        self._contactKey = storage.getValueWithKey(key: "ContactKey") ?? ""
    }
    
    func getContactKey() -> String? {
        
        self._contactKey = storage.getValueWithKey(key: "ContactKey") ?? ""
        //        logger.Log(message: "CONTACT_KEY is %s", logtype: .debug, argument: self._contactKey)
        return self._contactKey
    }
    
    func setToken(token: String) {
        
        self._token = token
        storage.setValueWithKey(value: token, key: "Token")
        logger.Log(message:"TOKEN %s", logtype: .debug, argument: self._token!)
        
    }
    
    func getToken() -> String?{
        
        self._token = storage.getValueWithKey(key: "Token")
        return self._token
    }
    
    func setAppVersion(appVersion: String) {
        
        self._appVersion = appVersion
    }
    
    func getAppversion() -> String? {
        
        return self._appVersion
    }
    
    
    func setPermission(permission: Bool?) {
        
        self._permission = permission
    }
    
    func getPermission() -> Bool? {
        
        return self._permission
    }
    
    func getUserAgent() -> String {
        
        return UAString()
    }
    
    func setEventApiUrl() {
        var eventUrl = (Bundle.main.object(forInfoDictionaryKey: "DengageEventApiUrl") as? String) ?? ""
        
        if(eventUrl.isEmpty)
        {
            eventUrl = EVENT_SERVICE_URL
        }
        
        storage.setValueWithKey(value: eventUrl, key: "EventUrl")
        logger.Log(message:"EVENT_API_URL is %s", logtype: .debug, argument: eventUrl)
    }
    
    func getEventApiUrl() -> String? {
        return storage.getValueWithKey(key: "EventUrl")
    }
    
    func setCampId(campId: String) {
        storage.setValueWithKey(value: campId, key: "dn_camp_id")
        setCampDate()
        logger.Log(message:"CAMP_ID is %s", logtype: .debug, argument: campId)
    }
    
    func getCampId()-> String? {
        
        return storage.getValueWithKey(key: "dn_camp_id")
    }
    
    func setSendId(sendId: String) {
        storage.setValueWithKey(value: sendId, key: "dn_send_id")
        logger.Log(message:"SEND_ID is %s", logtype: .debug, argument: sendId)
    }
    
    func getSendId()-> String? {
        
        return storage.getValueWithKey(key: "dn_send_id")
    }
    
    func setCampDate() {
        let date = NSDate() // Get Todays Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let stringDate: String = dateFormatter.string(from: date as Date)
        
        storage.setValueWithKey(value: stringDate, key: "dn_camp_date")
        logger.Log(message:"CampDate is %s", logtype: .debug, argument: stringDate)
    }
    
    func getCampDate()-> NSDate? {
        
        let dateFormatter = DateFormatter()
        // Our date format needs to match our input string format
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let campDate = storage.getValueWithKey(key: "dn_camp_date")
        let dateFromString = dateFormatter.date(from: campDate!)
        
        return dateFromString as NSDate?
    }
    
    func setReferrer(referrer: String) {
        self._referrer = referrer
    }
    
    func getReferrer()-> String? {
        return self._referrer
    }
}
