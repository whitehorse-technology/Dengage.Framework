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
    private var _integrationKey: String = ""
    private var _token: String? = ""
    private var _carrierId: String = ""
    private var _sdkVersion: String
    private var _advertisingId: String = ""
    private var _applicationIdentifier : String = ""
    private var _contactKey: String = ""
    private var _appVersion: String = ""
    private var _sessionId: String = ""
    private var _referrer: String = ""

    private var _testGroup: String = ""
    
    private var _badgeCountReset: Bool?
    private var _permission: Bool?
    private var _sessionStarted: Bool
    
    private var _useCloudForSubscription: Bool = false
    private var _registerForRemoteNotification: Bool = true
    
    init() {
        _sdkVersion = SDK_VERSION
        _permission = false
        _badgeCountReset = true
        storage = DengageLocalStorage.shared
        logger = SDKLogger.shared
        _sessionStarted = false
        
    }
    
    init(localStorage:  DengageLocalStorage = .shared, sdklogger: SDKLogger = .shared){
        
        storage = localStorage
        logger = sdklogger
        _sdkVersion = SDK_VERSION
        _permission = false
        _badgeCountReset = true
        _sessionStarted = false
    }
    

    // MARK: - Private functions
    final func setRegiterForRemoteNotification(enable: Bool)
    {
        self._registerForRemoteNotification = enable
    }
    
    final func getRegiterForRemoteNotification() -> Bool {
        
        return self._registerForRemoteNotification
    }
    
    final func setCloudEnabled(status: Bool) {
        self._useCloudForSubscription = status
    }
    
    final func getCloudEnabled() -> Bool {
        
        return self._useCloudForSubscription
    }
    
    final func setTestGroup(testGroup: String) {
        
        _testGroup = testGroup
    }
    
    final func getTestGroup() -> String {
        
        return _testGroup
    }
    
    final func setSessionStart(status: Bool) {
        self._sessionStarted = status
    }
    
    final func getSessionStart() -> Bool {
        
        return self._sessionStarted
    }
    
    final func setSessionId(sessionId: String) {
        
        self._sessionId = sessionId
    }
    
    final func getSessionId() -> String {
           
         return  self._sessionId
    }
       
    
    final func setSdkVersion(sdkVersion: String) {
        
        self._sdkVersion = sdkVersion
    }
    
    final func getSdkVersion() -> String {
        
        return self._sdkVersion
    }
    
    final func setCarrierId(carrierId: String) {
        
        self._carrierId = carrierId;
    }
    
    final func getCarrierId() -> String {
        
        return self._carrierId
    }
    
    final func setAdvertisingId(advertisingId:String) {
        
        self._advertisingId = advertisingId
    }
    
    final func getAdvertisinId() -> String? {
        
        return self._advertisingId
    }
    
    final func setApplicationIdentifier(applicationIndentifier: String) {
        
        self._applicationIdentifier = applicationIndentifier
    }
    
    final func getApplicationIdentifier() -> String {
        
        return _applicationIdentifier;
    }
    
    final func setDengageIntegrationKey(integrationKey: String) {
        
        self._integrationKey = integrationKey
    }
    
    final func getDengageIntegrationKey() -> String {
        
        return self._integrationKey
    }
    
    final func  setBadgeCountReset(badgeCountReset: Bool?) {
        
        self._badgeCountReset = badgeCountReset
    }
    
    final func getBadgeCountReset() -> Bool? {
        
        return self._badgeCountReset
    }
    
    final func setContactKey(contactKey: String?) {
        
        self._contactKey = contactKey ?? ""
        storage.setValueWithKey(value: contactKey ?? "", key: "ContactKey")
        self._contactKey = storage.getValueWithKey(key: "ContactKey") ?? ""
    }
    
    final func getContactKey() -> String? {
        
        self._contactKey = storage.getValueWithKey(key: "ContactKey") ?? ""
//        logger.Log(message: "CONTACT_KEY is %s", logtype: .debug, argument: self._contactKey)
        return self._contactKey
    }
    
    final func setToken(token: String) {
        
        self._token = token
        storage.setValueWithKey(value: token, key: "Token")
        logger.Log(message:"TOKEN %s", logtype: .debug, argument: self._token!)
        
    }
    
    final func getToken() -> String?{
        
        self._token = storage.getValueWithKey(key: "Token")
        return self._token
    }
    
    final func setAppVersion(appVersion: String) {
        
        self._appVersion = appVersion
    }
    
    final func getAppversion() -> String? {
        
        return self._appVersion
    }
    
    
    final func setPermission(permission: Bool?) {
        
        self._permission = permission
    }
    
    final func getPermission() -> Bool? {
        
        return self._permission
    }
    
    final func getUserAgent() -> String {
        
        return UAString()
    }
    
    final func setEventApiUrl() {
        var eventUrl = (Bundle.main.object(forInfoDictionaryKey: "DengageEventApiUrl") as? String) ?? ""
        
        if(eventUrl.isEmpty)
        {
            eventUrl = EVENT_SERVICE_URL
        }
        
        storage.setValueWithKey(value: eventUrl, key: "EventUrl")
        logger.Log(message:"EVENT_API_URL is %s", logtype: .debug, argument: eventUrl)
    }
    
    final func getEventApiUrl() -> String? {
        return storage.getValueWithKey(key: "EventUrl")
    }
    
    final func setCampId(campId: String) {
        storage.setValueWithKey(value: campId, key: "dn_camp_id")
        setCampDate()
        logger.Log(message:"CAMP_ID is %s", logtype: .debug, argument: campId)
    }
    
    final func getCampId()-> String? {
        
        return storage.getValueWithKey(key: "dn_camp_id")
    }
    
    final func setSendId(sendId: String) {
        storage.setValueWithKey(value: sendId, key: "dn_send_id")
        logger.Log(message:"SEND_ID is %s", logtype: .debug, argument: sendId)
    }
    
    final func getSendId()-> String? {
        
        return storage.getValueWithKey(key: "dn_send_id")
    }
    
    final func setCampDate() {
        let date = NSDate() // Get Todays Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let stringDate: String = dateFormatter.string(from: date as Date)
        
        storage.setValueWithKey(value: stringDate, key: "dn_camp_date")
        logger.Log(message:"CampDate is %s", logtype: .debug, argument: stringDate)
    }
    
    final func getCampDate()-> NSDate? {
        
        let dateFormatter = DateFormatter()
        // Our date format needs to match our input string format
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let campDate = storage.getValueWithKey(key: "dn_camp_date")
        let dateFromString = dateFormatter.date(from: campDate!)
        
        return dateFromString as NSDate?
    }
    
    final func setReferrer(referrer: String) {
        self._referrer = referrer
    }
    
    final func getReferrer()-> String? {
        return self._referrer
    }
}
