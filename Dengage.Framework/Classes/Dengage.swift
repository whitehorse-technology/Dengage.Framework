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
    
    // MARK:- Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest : UNNotificationRequest, withNotificationContent : UNMutableNotificationContent){
        
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest, withNotificationContent: withNotificationContent)
    }
    
    
    
    
    
    
    

}


