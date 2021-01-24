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
    static var baseService = BaseService()
    static var sessionManager: SessionManager = .shared

    static var utilities: Utilities = .shared
    static var settings: Settings = .shared
    static var logger: SDKLogger = .shared
    static var localStorage: DengageLocalStorage = .shared

    // MARK: - Initialize Methods
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
        settings.removeTokenIfNeeded()
        configureSettings()
        Dengage.syncSubscription()
        Dengage.getInitalInboxMessages()
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

    // MARK: - Private Methods
    static func configureSettings() {

        settings.setCarrierId(carrierId: utilities.identifierForCarrier())
        settings.setAdvertisingId(advertisingId: utilities.identifierForAdvertising())
        settings.setApplicationIdentifier(applicationIndentifier: utilities.identifierForApplication())
        settings.setAppVersion(appVersion: utilities.indentifierForCFBundleShortVersionString())
    }
}

// MARK: - Inbox
extension Dengage {
    public static func getInboxMessages(offset: Int,
                                        limit: Int = 20,
                                        completion: @escaping (Result<[DengageMessage], Error>) -> Void) {
        guard offset != 1 else {
            let messages = localStorage.getInboxMessages()
            completion(.success(messages))
            return
        }
        let contactKey = settings.getContactKey() ?? settings.getApplicationIdentifier()
        let request = GetMessagesRequest(contactKey: contactKey,
                                         offset: offset,
                                         limit: limit)
        baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public static func deleteInboxMessage(with id: String,
                                          completion: @escaping (Result<Bool, Error>) -> Void) {
        let messages = localStorage.getInboxMessages().filter {$0.id != id}
        localStorage.saveMessages(with: messages)
        let contactKey = settings.getContactKey() ?? settings.getApplicationIdentifier()
        let request = DeleteMessagesRequest(contactKey: contactKey, id: id)
        baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public static func markInboxMessageAsRead(with id: String,
                                              completion: @escaping (Result<Bool, Error>) -> Void) {
        markLocalMessageIfNeeded(with: id)
        let contactKey = settings.getContactKey() ?? settings.getApplicationIdentifier()
        let request = MarkAsReadRequest(contactKey: contactKey, id: id)
        baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getInitalInboxMessages() {
        let contactKey = settings.getContactKey() ?? settings.getApplicationIdentifier()
        let request = GetMessagesRequest(contactKey: contactKey,
                                         offset: 1,
                                         limit: 20)
        baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                localStorage.saveMessages(with: response.messages)
            case .failure:
                break
            }
        }
    }

    static func markLocalMessageIfNeeded(with id: String?) {
        guard let messageId = id else { return }
        var messages = localStorage.getInboxMessages()
        var message = messages.first(where: {$0.id == messageId})
        message?.isClicked = true
        messages = messages.filter {$0.id != messageId}
        guard let readedMessage = message else { return }
        messages.append(readedMessage)
        localStorage.saveMessages(with: messages)
    }
}
