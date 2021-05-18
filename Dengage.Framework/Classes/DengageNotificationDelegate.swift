//
//  DengageNotificationDelegate.swift
//  dengage.ios.sdk
//
//  Created by Developer on 15.08.2019.
//  Copyright © 2019 Dengage All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI
import os.log
import SafariServices
import UIKit

class DengageNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    let openEventService: OpenEventService!
    let transactionalOpenEventService: TransactioanlOpenEventService!
    let settings: Settings!
    var delegate: UNUserNotificationCenterDelegate?
    
    var openTriggerCompletionHandler: ((_ notificationResponse: UNNotificationResponse) -> Void)?
    
    override init() {
        
        settings = Settings.shared
        openEventService = OpenEventService()
        transactionalOpenEventService = TransactioanlOpenEventService()
        self.delegate = nil
        
        super.init()
    }
    
    init(settings: Settings = .shared,
         openEventService: OpenEventService,
         transactionalOpenEventService: TransactioanlOpenEventService) {
        
        self.settings = settings
        self.openEventService = openEventService
        self.transactionalOpenEventService = transactionalOpenEventService
        self.delegate = nil
    }

    @available(iOS 10.0, *)
    final func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    @available(iOS 10.0, *)
    final func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      didReceive response: UNNotificationResponse,
                                      withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let content = response.notification.request.content
        guard let messageSource = content.userInfo["messageSource"] as? String,
              MESSAGE_SOURCE == messageSource else {
            delegate?.userNotificationCenter?(center, didReceive: response, withCompletionHandler: completionHandler)
            return
        }
        let actionIdentifier = response.actionIdentifier
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            os_log("UNNotificationDismissActionIdentifier TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: content, actionIdentifier: "DismissAction")
        case UNNotificationDefaultActionIdentifier:
            os_log("UNNotificationDefaultActionIdentifier TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: content, actionIdentifier: "")
        default:
            os_log("ACTION_ID: %s TRIGGERED", log: .default, type: .debug, actionIdentifier)
            sendEventWithContent(content: content, actionIdentifier: actionIdentifier)
            checkTargetUrlInActionButtons(content: content, actionIdentifier: actionIdentifier)
        }
        
        openTriggerCompletionHandler?(response)
    
        if settings.disableOpenURL {
            delegate?.userNotificationCenter?(center,
                                              didReceive: response,
                                              withCompletionHandler: completionHandler)
        }else{
            checkTargetUrl(content: content)
        }
      
        parseCampIdAndSendId(content: content)
        let refferer = parseReferrer(content: content)
        DengageEvent.shared.SessionStart(referrer: refferer, restart: true)
        completionHandler()
    }
    
    final func parseReferrer(content: UNNotificationContent) -> String {
        return content.userInfo["targetUrl"] as? String ?? ""
    }
    
    final func parseCampIdAndSendId(content: UNNotificationContent) {
        guard let sendId = content.userInfo["dengageSendId"] as? String else { return }
        settings.setSendId(sendId: sendId)
    }

    final func openDeeplink(link: String?) {
        guard let urlString = link, let url = URL(string: urlString) else { return }
        os_log("TARGET_URL is %s", log: .default, type: .debug, link!)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    final func checkTargetUrl(content: UNNotificationContent) {
        
        let targetUrl = content.userInfo["targetUrl"] as? String
        
        if targetUrl?.isEmpty == false {
            openDeeplink(link: targetUrl)
        }
    }

    final func checkTargetUrlInActionButtons(content: UNNotificationContent,
                                             actionIdentifier: String) {
        
        guard let actionButtons = content.userInfo["actionButtons"] else { return }
                
        let actionButtonArray = actionButtons as! NSArray
        
        for item in actionButtonArray {
            let dic = item as! NSDictionary
            let id = dic.value(forKey: "id") as! String
            
            if id == actionIdentifier {
                
                let link = dic.value(forKey: "targetUrl") as? String
                
                if link?.isEmpty == false {
                    os_log("Action Button Target URL IS %s", log: .default, type: .debug, link!)
                    openDeeplink(link: link)
                }
            }
        }
    }

    final func sendEventWithContent(content: UNNotificationContent,
                                    actionIdentifier: String?) {
        
        guard let messageId = content.userInfo["messageId"] as? Int else { return }
        os_log("MSG_ID is %s", log: .default, type: .debug, String(messageId))
        
        guard let messageDetails = content.userInfo["messageDetails"] as? String else { return }
        
        os_log("MSG_DETAILS is %s", log: .default, type: .debug, messageDetails)
        
        if actionIdentifier?.isEmpty == false {
            os_log("BUTTON_ID is %s", log: .default, type: .debug, actionIdentifier!)
        }
        
        if let transactionId = content.userInfo["transactionId"] as? String {
            os_log("TRANSACTION_ID is %s", log: .default, type: .debug, transactionId)
            sendTransactionalOpenEvent(messageId: messageId,
                                       transactionId: transactionId,
                                       messageDetails: messageDetails,
                                       buttonId: actionIdentifier)
        } else {
            sendOpenEvent(messageId: messageId, messageDetails: messageDetails, buttonId: actionIdentifier)
        }
    }

    final func sendOpenEvent(messageId: Int,
                             messageDetails: String,
                             buttonId: String?) {
        
        var openEventHttpRequest = OpenEventHttpRequest()
        openEventHttpRequest.messageId = messageId
        openEventHttpRequest.messageDetails = messageDetails
        openEventHttpRequest.integrationKey = settings.getDengageIntegrationKey()
        openEventHttpRequest.buttonId = buttonId ?? ""
        
        
        openEventService.postOpenEvent(openEventHttpRequest: openEventHttpRequest)
        if settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    final func sendTransactionalOpenEvent(messageId: Int,
                                          transactionId: String,
                                          messageDetails: String,
                                          buttonId: String?) {
        
        var transactionalOpenEventHttpRequest = TransactionalOpenEventHttpRequest()
        transactionalOpenEventHttpRequest.integrationId = settings.getDengageIntegrationKey()
        transactionalOpenEventHttpRequest.messageId = messageId
        transactionalOpenEventHttpRequest.transactionId = transactionId
        transactionalOpenEventHttpRequest.messageDetails = messageDetails
        transactionalOpenEventHttpRequest.buttonId =  buttonId ?? ""
        
        transactionalOpenEventService.postOpenEvent(transactionalOpenEventHttpRequest:
            transactionalOpenEventHttpRequest)
        
        if settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
