//
//  Dengage_Objc.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 12.04.2021.
//

import Foundation
extension Dengage {
    
    @available(iOS 10.0, *)
    @objc public static func initWithLaunchOptions(categories: Set<UNNotificationCategory>,
                                                   withLaunchOptions: [UIApplication.LaunchOptionsKey: Any],
                                                   badgeCountReset: Bool = false) {
        let currentNotificationCenter = center.delegate
        notificationDelegate.delegate = currentNotificationCenter
        center.delegate = notificationDelegate
        settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        settings.removeTokenIfNeeded()
        configureSettings()
        Dengage.syncSubscription()
        Dengage.getSDKParams()
        center.setNotificationCategories(categories)
    }
    @available(iOSApplicationExtension 10.0, *)
    @objc public static func objc_didReceiveNotificationExtentionRequest(receivedRequest: UNNotificationRequest,
                                                              withNotificationContent: UNMutableNotificationContent) {
        Dengage.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest,
                                                       withNotificationContent: withNotificationContent)
       
    }
    
    @objc public static func getInboxMessages(offset: Int,
                                              limit: Int = 20,
                                              success: @escaping (([DengageMessage]) -> Void),
                                              error: @escaping ((Error) -> Void)) {
        Dengage.getInboxMessages(offset: offset, limit: limit) { result in
            switch result {
            case .success(let messages):
                success(messages)
            case .failure(let errorValue):
                error(errorValue)
            }
        }
    }
    
    @objc public static func deleteInboxMessage(with id: String,
                                                success: @escaping (() -> Void),
                                                error: @escaping ((Error) -> Void)){
        Dengage.deleteInboxMessage(with: id) { result in
            switch result {
            case .success(_):
                success()
            case .failure(let errorValue):
                error(errorValue)
            }
        }
    }
    
    @objc public static func setInboxMessageAsClicked(with id: String,
                                                      success: @escaping (() -> Void),
                                                      error: @escaping ((Error) -> Void)){
        Dengage.setInboxMessageAsClicked(with: id) { result in
            switch result {
            case .success(_):
                success()
            case .failure(let errorValue):
                error(errorValue)
            }
        }
    }
    
    @objc public static func objc_setNavigation(screenName:String? = nil ){
        Dengage.setNavigation(screenName: screenName)
    }
    
    @objc public static func objc_setTags(_ tags: [TagItem]){
        Dengage.setTags(tags)
    }
    
    @objc public static func objc_sendOpenEvent(messageId: Int,
                                           messageDetails: String,
                                           buttonId: String?) {
        Dengage.sendOpenEvent(
            messageId: messageId,
            messageDetails: messageDetails,
            buttonId: buttonId
        )
    }
}
