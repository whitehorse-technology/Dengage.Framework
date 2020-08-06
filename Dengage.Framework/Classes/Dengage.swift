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

public class Dengage {
    
    static var center = UNUserNotificationCenter.current()
    
    static var notificationDelegate = DengageNotificationDelegate()
    static var openEventService: OpenEventService = OpenEventService()
    static var eventCollectionService: EventCollectionService = EventCollectionService()
    static var sessionManager:  SessionManager = .shared
    
    static var utilities: Utilities = .shared
    static var settings: Settings = .shared
    static var logger: SDKLogger = .shared
    static var eventQueue: EventQueue = EventQueue()
    
    
    //  MARK: - Initialize Methods
    /// Initiliazes SDK requiered parameters.
    ///
    /// -  Usage:
    ///
    ///      Dengage.initWithLaunchOptions(categories: [], withLaunchOptions: launchOptions, badgeCountReset: true)
    ///
    /// - Parameter categories: *categories* custom action buttons
    /// - Parameter withLaunchOptions: *withLaunchOptions*
    /// - Parameter badgeCountReset: *badgeCountReset* clears badge count icon on notification enable
    @available(iOS 10.0, *)
    // will support rich notifications with categories
    public static func initWithLaunchOptions(categories: Set<UNNotificationCategory>?,
                                             withLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                             badgeCountReset: Bool?) {
        
        center.delegate = notificationDelegate
        
        settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
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
    public static func initWithLaunchOptions(withLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?, badgeCountReset: Bool?) {
        
        center.delegate = notificationDelegate
        settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        ConfigureSettings()
    }
    
    // MARK: - Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest: UNNotificationRequest, withNotificationContent: UNMutableNotificationContent) {
        
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest, withNotificationContent: withNotificationContent)
    }
    
    // MARK: - Private Methods
    static func ConfigureSettings() {

        settings.setCarrierId(carrierId: utilities.identifierForCarrier())
        settings.setAdvertisingId(advertisingId: utilities.identifierForAdvertising())
        settings.setApplicationIdentifier(applicationIndentifier: utilities.identifierForApplication())
        settings.setAppVersion(appVersion: utilities.indentifierForCFBundleShortVersionString())
        settings.setEventApiUrl()
    }
    
    @available(swift, deprecated: 2.5.0)
    static func StartSession(actionUrl: String?){
        
        if settings.getSessionStart() {
            
            return
        }
        
        let session = sessionManager.getSession()
        
        settings.setSessionId(sessionId: session.Id)
        
        DengageEventCollecitonService.shared.startSession(actionUrl: actionUrl)
    }
}
