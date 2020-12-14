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
    static var sessionManager: SessionManager = .shared
    
    static var utilities: Utilities = .shared
    static var settings: Settings = .shared
    static var logger: SDKLogger = .shared
    static var localStorage: DengageLocalStorage = .shared
    static var eventQueue: EventQueue = EventQueue()
    
    //MARK: - Initialize Methods
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
    public static func initWithLaunchOptions(categories: Set<UNNotificationCategory>? = nil,
                                             withLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                             badgeCountReset: Bool? = nil, appGroupName: String? = nil) {
        let currentNotificationCenter = center.delegate
        notificationDelegate.delegate = currentNotificationCenter
        center.delegate = notificationDelegate
        settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        configureSettings()
        Dengage.syncSubscription()
        INBOX_SUIT_NAME = appGroupName
        guard let pushCategories = categories else {return}
        center.setNotificationCategories(pushCategories)
    }
    
    // MARK: - Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest: UNNotificationRequest,
                                                              withNotificationContent: UNMutableNotificationContent) {
        
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest,
                                                                                   withNotificationContent: withNotificationContent)
    }
    
    //MARK: - Private Methods
    static func configureSettings() {
        
        settings.setCarrierId(carrierId: utilities.identifierForCarrier())
        settings.setAdvertisingId(advertisingId: utilities.identifierForAdvertising())
        settings.setApplicationIdentifier(applicationIndentifier: utilities.identifierForApplication())
        settings.setAppVersion(appVersion: utilities.indentifierForCFBundleShortVersionString())
    }
}

//MARK: - Inbox
extension Dengage {
    public static func getInboxMessages() -> [DengageMessage]{
        let messages = localStorage.getInboxMessages().filter{ item in
            guard let itemDate = item.expireDate else {return false}
            return itemDate > Date()
        }
        return messages.sorted(by: { firstItem, secondItem in
            guard let firstExpireDate = firstItem.expireDate,
                  let secondExpireDate = secondItem.expireDate else {return false}
            return firstExpireDate < secondExpireDate
        })
    }
    
    public static func deleteInboxMessage(with id: String){
        let messages = Dengage.getInboxMessages().filter{$0.id != id}
        localStorage.saveMessages(with: messages)
    }
    
    public static func markInboxMessageAsRead(with id: String?){
        guard let messageId = id else { return }
        var messages = Dengage.getInboxMessages()
        var message = messages.first(where: {$0.id == messageId})
        message?.isRead = true
        messages = messages.filter{$0.id != messageId}
        guard let readedMessage = message else { return }
        messages.append(readedMessage)
        localStorage.saveMessages(with: messages)
    }
    
    static func saveNewMessageIfNeeded(with content: UNNotificationContent){
        guard let message = DengageMessage(with: content) else {return}
        var messages = Dengage.getInboxMessages().filter{$0.id != message.id}
        messages.append(message)
        localStorage.saveMessages(with: messages)
    }
}

