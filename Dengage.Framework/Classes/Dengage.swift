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
    static var _dengageEventCollectionService : DengageEventCollecitonService = .shared
    static var _sessionManager :  SessionManager = .shared
    static var IsUserGranted : Bool = false
    
    static var _utilities : Utilities = .shared
    static var _settings : Settings = .shared
    static var _logger : SDKLogger = .shared
    static var _eventQueue : EventQueue = EventQueue()

    
    //  MARK:- Initialize Methods
    /// Initiliazes SDK requiered parameters.
    ///
    /// -  Usage:
    ///
    ///      Dengage.initWithLaunchOptions(categories : [], withLaunchOptions: launchOptions, badgeCountReset: true)
    ///
    /// - Parameter categories : *categories* custom action buttons
    /// - Parameter withLaunchOptions: *withLaunchOptions*
    /// - Parameter badgeCountReset: *badgeCountReset* clears badge count icon on notification enable
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
            
            center.setNotificationCategories(categories!)
        }
    }
    
    /// Initiliazes SDK requiered parameters.
    ///
    ///
    /// - Usage:
    ///
    ///      Dengage.initWithLaunchOptions(withLaunchOptions: launchOptions, badgeCountReset: true)
    ///
    /// - Parameter withLaunchOptions: *withLaunchOptions*
    /// - Parameter badgeCountReset: *badgeCountReset* clears badge count icon on notification enable
    @available(iOS 10.0, *)
    public static func initWithLaunchOptions(withLaunchOptions : [UIApplication.LaunchOptionsKey: Any]?, badgeCountReset : Bool?) {
        
        center.delegate = notificationDelegate
        _settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        ConfigureSettings()
    }
    
    // MARK:- Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest : UNNotificationRequest, withNotificationContent : UNMutableNotificationContent){
        
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest, withNotificationContent: withNotificationContent)
    }
    
    // MARK:- Private Methods
    static func ConfigureSettings(){
        
        _settings.setCarrierId(carrierId: _utilities.identifierForCarrier())
        _settings.setAdvertisingId(advertisingId: _utilities.identifierForAdvertising())
        _settings.setApplicationIdentifier(applicationIndentifier: _utilities.identifierForApplication())
        _settings.setAppVersion(appVersion: _utilities.indentifierForCFBundleShortVersionString())
        _settings.setEventApiUrl()
    }
    
    static func StartSession(actionUrl: String?){
        
        if _settings.getSessionStart() {
            
            return
        }
        
        let session = _sessionManager.getSession()
        
        _settings.setSessionId(sessionId: session.Id)
        
        _dengageEventCollectionService.startSession(actionUrl: actionUrl)
    }
}
