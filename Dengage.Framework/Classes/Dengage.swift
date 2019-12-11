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
    static var subscriptionService = SubscriptionService()
    static var openEventService = OpenEventService()
    static var eventCollectionService = EventCollectionService()
    static var IsUserGranted : Bool = false
    
    static var utilities = Utilities.shared
    static var settings = Settings.shared
    
//  MARK:- İnitialize Methods
    
    @available(iOS 10.0, *)
    // will support rich notifications with categories
    static func initWithLaunchOptions(categories : Set<UNNotificationCategory>?, withLaunchOptions : [UIApplication.LaunchOptionsKey: Any]?) throws {
        
        center.delegate = notificationDelegate
        
        ConfigureSettings()

        
        if(categories != nil)
        {
            if (categories!.count < 0 || categories!.count == 0)
            {
                throw ValidationError.EmptyCategories
            }
            
            center.setNotificationCategories(categories!)
            
        }
    }
    
    @available(iOS 10.0, *)
    public static func initWithLaunchOptions(withLaunchOptions : [UIApplication.LaunchOptionsKey: Any]?, badgeCountReset : Bool?) throws {
        
        center.delegate = notificationDelegate
        
        settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        ConfigureSettings()
        
    }
    
    // MARK:- Prompt Methods
    
    public static func promptForPushNotifications()
    {
        let queue = DispatchQueue(label: "subscription-queue", qos: .userInitiated)
        
        center
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [self] granted, error in
                
                IsUserGranted = granted
                
                guard granted else
                {
                    SDKLogger.shared.Log(message: "PERMISSION_NOT_GRANTED %s", logtype: .debug, argument: String(granted))
                    Settings.shared.setPermission(permission: IsUserGranted)
                    
                    queue.async {
                        Dengage.SyncSubscription()
                    }
                    return
                }
                
                Settings.shared.setPermission(permission: IsUserGranted)
                self.getNotificationSettings()
                
                
                SDKLogger.shared.Log(message: "PERMISSION_GRANTED %s", logtype: .debug, argument: String(granted))
                queue.async {
                     Dengage.SyncSubscription()
                }
                
        }
    }
    
    static func getNotificationSettings() {
        
        center.getNotificationSettings { settings in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async{
                
                SDKLogger.shared.Log(message: "REGISTER_TOKEN", logtype: .debug)
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
    @available(*, renamed: "setIntegrationKey")
    public static func setIntegrationKey(key: String){
        
        settings.setDengageIntegrationKey(integrationKey: key)
    }
    
    /// Set Contact Key ( Optional )
    /// ```
    /// self.setContactKey(contactKey: "adamsmith@acme.com")
    /// ```
    public static func setContactKey(contactKey : String?){
        
        settings.setContactKey(contactKey: contactKey)
    }
    
    /// Set Apns Token
    /// ```
    /// self.setToken(token: "")
    /// ```
    public static func setToken(token: String){
        
        settings.setToken(token: token)
    }
    
    @available(*,deprecated)
    public static func setAccountId(accountId: String){
        
        settings.setAccountId(accountId: accountId)
    }
    
    public static func setUserPermission(permission : Bool){
        
        settings.setPermission(permission: permission)
    }
    
    public static func setLogStatus(isVisible : Bool){
        
        SDKLogger.shared.setIsDisabled(isDisabled: isVisible)
    }
    
    public static func getDeviceId() -> String? {
        
        return settings.getApplicationIdentifier()
    }
    
    // MARK:- Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest : UNNotificationRequest, with : UNMutableNotificationContent){
        
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest, with: with)
    }
    
//    MARK:-
//    MARK:- API calls
    @available(*, renamed: "SendSubscriptionEvent")
    public static func SyncSubscription() -> Bool {
        
        
        if(settings.getAdvertisinId()!.isEmpty){
            SDKLogger.shared.Log(message: "ADV_ID_IS_EMPTY", logtype: .info)
            return false
        }
        if(settings.getApplicationIdentifier().isEmpty){
            SDKLogger.shared.Log(message: "APP_IDF_ID_IS_EMPTY", logtype: .info)
            return false
        }
        
        subscriptionService.SendSubscriptionEvent()
        return true
    }
    
    @available(*, renamed: "SendEventCollection")
    public static func SendDeviceEvent(toEventTable: String, andWithEventDetails: NSDictionary) -> Bool {
        
        if Settings.shared.getAccountId().isEmpty{
            SDKLogger.shared.Log(message: "ACCOUNT_ID_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            SDKLogger.shared.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.key = settings.getApplicationIdentifier()
        eventCollectionModel.eventDetails = andWithEventDetails
        
        eventCollectionService.PostEventCollection(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    public static func SendCustomEvent(toEventTable: String, withKey : String, andWithEventDetails: NSDictionary) -> Bool {
           
           if Settings.shared.getAccountId().isEmpty{
               SDKLogger.shared.Log(message: "ACCOUNT_ID_IS_EMPTY", logtype: .info)
               return false
           }
           
           if toEventTable.isEmpty {
               SDKLogger.shared.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
               return false
           }
           
           var eventCollectionModel = EventCollectionModel()
           
           eventCollectionModel.eventTable = toEventTable
           eventCollectionModel.key = withKey
           eventCollectionModel.eventDetails = andWithEventDetails
           
           eventCollectionService.PostEventCollection(eventCollectionModel: eventCollectionModel)
           return true
       }
    
    static func ConfigureSettings(){
        
        settings.setCarrierId(carrierId: utilities.identifierForCarrier())
        settings.setAdvertisingId(advertisingId: utilities.identifierForAdvertising())
        settings.setApplicationIdentifier(applicationIndentifier: utilities.identifierForApplication())
        settings.setAppVersion(appVersion: utilities.indentifierForCFBundleShortVersionString())
    }
  
}


