//
//  Dengage.swift
//  dengage.ios.sdk
//
//  Created by Developer on 20.09.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import UserNotifications
import AdSupport


public class Dengage
{
    static var center = UNUserNotificationCenter.current()
    
    static var notificationDelegate = DengageNotificationDelegate()
    static var _subscriptionService : SubscriptionService = SubscriptionService()
    static var _openEventService : OpenEventService = OpenEventService()
    static var _eventCollectionService : EventCollectionService = EventCollectionService()
    static var _dengageEventCollectionService : DengageEventCollecitonService = DengageEventCollecitonService()
    static var _sessionManager :  SessionManager = .shared
    static var IsUserGranted : Bool = false
    
    static var _utilities : Utilities = .shared
    static var _settings : Settings = .shared
    static var _logger : SDKLogger = .shared
    static var _eventQueue : EventQueue = EventQueue()
    static var _dengageCategories : DengageCategories = .init(notificationCenter: center)
    
    //  MARK:- İnitialize Methods
    
    @available(iOS 10.0, *)
    // will support rich notifications with categories
    public static func initWithLaunchOptions(categories : Set<UNNotificationCategory>?, withLaunchOptions : [UIApplication.LaunchOptionsKey: Any]?, badgeCountReset : Bool?) {
        
        center.delegate = notificationDelegate
        
        _settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        ConfigureSettings()
        
        
        if(categories != nil)
        {
            if (categories!.count < 0 || categories!.count == 0)
            {
                return
            }
            
            _dengageCategories.registerCategories(categories: categories!)
            
        }
    }
    
    @available(iOS 10.0, *)
    public static func initWithLaunchOptions(withLaunchOptions : [UIApplication.LaunchOptionsKey: Any]?, badgeCountReset : Bool?) {
        
        center.delegate = notificationDelegate
        _settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        ConfigureSettings()
        _dengageCategories.registerCategories()

    }
    
    
    // MARK:- Prompt Methods
    
    /// Handles  notification permission
    /// Sends subscription request
    public static func promptForPushNotifications()
    {
        let queue = DispatchQueue(label: SUBSCRIPTION_QUEUE, qos: .userInitiated)
        
        center
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [self] granted, error in
                
                IsUserGranted = granted
                
                guard granted else
                {
                    _logger.Log(message: "PERMISSION_NOT_GRANTED %s", logtype: .debug, argument: String(granted))
                    _settings.setPermission(permission: IsUserGranted)
                    
                    queue.async {
                        Dengage.SyncSubscription()
                    }
                    return
                }
                
                _settings.setPermission(permission: IsUserGranted)
                self.getNotificationSettings()
                
                
                _logger.Log(message: "PERMISSION_GRANTED %s", logtype: .debug, argument: String(granted))
                queue.async {
                    Dengage.SyncSubscription()
                }
                
        }
    }
    
    static func getNotificationSettings() {
        
        center.getNotificationSettings { settings in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async{
                
                _logger.Log(message: "REGISTER_TOKEN", logtype: .debug)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //    MARK:-
    //    MARK:- Setters
    /// Set  Integration Key ( Required )
    /// ```
    /// self.setDengageIntegrationKey(key: "...")
    /// ```
    @available(*, renamed: "setDengageIntegrationKey")
    public static func setIntegrationKey(key: String){
        
        _settings.setDengageIntegrationKey(integrationKey: key)
    }
    
    /// Set Contact Key ( Optional )
    /// ```
    /// self.setContactKey(contactKey: "adamsmith@acme.com")
    /// ```
    public static func setContactKey(contactKey : String?){
        
        _settings.setContactKey(contactKey: contactKey)
    }
    
    /// Set Apns Token
    /// ```
    /// self.setToken(token: "")
    /// ```
    public static func setToken(token: String){
        
        _settings.setToken(token: token)
    }
    
    /// Set  User Permission manually
    /// ```
    /// self.setUserPermission(permission: true)
    /// ```
    public static func setUserPermission(permission : Bool){
        
        _settings.setPermission(permission: permission)
    }
    
    /// Set  Log Status if you want to display logs
    /// ```
    /// self.setLogStatus(isVisible: true)
    /// ```
    public static func setLogStatus(isVisible : Bool){
        
        _logger.setIsDisabled(isDisabled: isVisible)
    }
    
    public static func getDeviceId() -> String? {
        
        return _settings.getApplicationIdentifier()
    }
    
    // MARK:- Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest : UNNotificationRequest, withNotificationContent : UNMutableNotificationContent){
        
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest, withNotificationContent: withNotificationContent)
    }
    
    //    MARK:-
    //    MARK:- API calls
    @available(*, renamed: "SendSubscriptionEvent")
    public static func SyncSubscription() {
        
        
        if(_settings.getAdvertisinId()!.isEmpty){
            _logger.Log(message: "ADV_ID_IS_EMPTY", logtype: .info)
            return
        }
        if(_settings.getApplicationIdentifier().isEmpty){
            _logger.Log(message: "APP_IDF_ID_IS_EMPTY", logtype: .info)
            return
        }
        
        if _settings.getSubscriptionUrl().isEmpty {
            _subscriptionService.SendSubscriptionEvent()
        }
        else{
            
            startSession(actionUrl: "")
            _dengageEventCollectionService.subscriptionEvent()
            
        }
        
    }
    
    @available(*, renamed: "SendEventCollection")
    public static func SendDeviceEvent(toEventTable: String, andWithEventDetails: NSDictionary) -> Bool {
        
        if _settings.getDengageIntegrationKey().isEmpty{
            _logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            _logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.key = _settings.getApplicationIdentifier()
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.eventDetails = andWithEventDetails
        
        SyncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    public static func SendCustomEvent(toEventTable: String, withKey : String, andWithEventDetails: NSDictionary) -> Bool {
        
        if _settings.getDengageIntegrationKey().isEmpty{
            _logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            _logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.key = withKey
        eventCollectionModel.eventDetails = andWithEventDetails
        
        SyncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    static func ConfigureSettings(){
        
        _settings.setCarrierId(carrierId: _utilities.identifierForCarrier())
        _settings.setAdvertisingId(advertisingId: _utilities.identifierForAdvertising())
        _settings.setApplicationIdentifier(applicationIndentifier: _utilities.identifierForApplication())
        _settings.setAppVersion(appVersion: _utilities.indentifierForCFBundleShortVersionString())
    }
    
    static func SyncEventQueues(eventCollectionModel: EventCollectionModel) {
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .userInitiated)
        
        if(_eventQueue.items.count < QUEUE_LIMIT)
        {
            _eventQueue.enqueue(element: eventCollectionModel)
        }
        else{
            
            _logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
            while _eventQueue.items.count > 0 {
                
                let eventcollection  = _eventQueue.dequeue()!
                
                queue.async {
                    _eventCollectionService.PostEventCollection(eventCollectionModel: eventcollection)
                }
            }
            _logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
            
            _eventQueue.enqueue(element: eventCollectionModel)
        }

    }
    
    public static func SyncEventQueues(){
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .userInitiated)
        
        if(_eventQueue.items.count > QUEUE_LIMIT)
        {
            _logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
            while _eventQueue.items.count > 0 {
                
                let eventcollection  = _eventQueue.dequeue()!
                
                queue.async {
                    _eventCollectionService.PostEventCollection(eventCollectionModel: eventcollection)
                }
            }
            _logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
        }
    }
    
    
    public static func HandleNotificationActionBlock(callback: @escaping (_ notificationResponse : UNNotificationResponse)-> ()){
        
        notificationDelegate.openTriggerCompletionHandler = {
            
           response in
            
            callback(response)
            
            
        }
    }
    
    public static func startSession(actionUrl: String?){
        
        let session = _sessionManager.getSession()
        
        _settings.setSessionId(sessionId: session.Id)
        _dengageEventCollectionService.startSession(actionUrl: actionUrl)
    }
    
    public static func pageView(params : NSMutableDictionary){
        
        _dengageEventCollectionService.pageView(params: params)
    }
    
    public static func customEvent(eventName: String, params : NSMutableDictionary){
           
        _dengageEventCollectionService.customEvent(eventName: eventName, params: params)
    }
    
    
}


