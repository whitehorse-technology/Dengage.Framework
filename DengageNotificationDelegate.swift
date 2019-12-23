//
//  DengageNotificationDelegate.swift
//  dengage.ios.sdk
//
//  Created by Developer on 15.08.2019.
//  Copyright © 2019 Whitehorse.Technology All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI
import os.log


class DengageNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    let _openEventService : OpenEventService!
    let _transactionalOpenEventService : TransactioanlOpenEventService!
    let _settings : Settings!
    
    override init() {
        
        _settings = Settings.shared
        _openEventService = OpenEventService()
        _transactionalOpenEventService = TransactioanlOpenEventService()
        
        super.init()
    }
    
    init(settings : Settings = .shared, openEventService : OpenEventService , transactionalOpenEventService : TransactioanlOpenEventService){
        
        _settings = settings
        _openEventService = openEventService
        _transactionalOpenEventService = transactionalOpenEventService
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier
        {
        case UNNotificationDismissActionIdentifier:
            os_log("UNNotificationDismissActionIdentifier TRIGGERED", log: .default, type: .info)
        case UNNotificationDefaultActionIdentifier:
            os_log("UNNotificationDefaultActionIdentifier TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        case YES_ACTION:
            os_log("YES ACTION TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        case NO_ACTION:
            os_log("NO_ACTION TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        case ACCEPT_ACTION:
            os_log("ACCEPT_ACTION TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        case DECLINE_ACTION:
            os_log("DECLINE_ACTION TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        case CONFIRM_ACTION:
            os_log("CONFIRM_ACTION TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        case CANCEL_ACTION:
            os_log("CANCEL_ACTION TRIGGERED", log: .default, type: .info)
            sendEventWithContent(content: response.notification.request.content)
        default:
            sendEventWithContent(content: response.notification.request.content)
            
        }
        completionHandler()
    }
    
    
    func sendEventWithContent(content:UNNotificationContent){
        
        var messageId = 0
        if(content.userInfo["messageId"] != nil){
            messageId = content.userInfo["messageId"] as! Int;
            os_log("MSG_ID is %s", log: .default, type: .debug, String(messageId))
        }
        
        var messageDetails = ""
        if(content.userInfo["messageDetails"] != nil){
            messageDetails = content.userInfo["messageDetails"] as! String;
            os_log("MSG_DETAILS is %s", log: .default, type: .debug, messageDetails)
        }
        
        var transactionId = ""
        if(content.userInfo["transactionId"] != nil){
            transactionId = content.userInfo["transactionId"] as! String;
            os_log("TRANSACTION_ID is %s", log: .default, type: .debug, transactionId)
            sendTransactionalOpenEvent(messageId: messageId, transactionId: transactionId, messageDetails: messageDetails)
        }else{
            sendOpenEvent(messageId: messageId, messageDetails: messageDetails)
        }
    }
    
    
    func sendOpenEvent(messageId : Int, messageDetails : String) {
        
        var openEventHttpRequest = OpenEventHttpRequest()
        openEventHttpRequest.messageId = messageId
        openEventHttpRequest.messageDetails = messageDetails
        openEventHttpRequest.integrationKey = _settings.getDengageIntegrationKey()
        
        _openEventService.PostOpenEvent(openEventHttpRequest: openEventHttpRequest)
        if _settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
    
    
    func sendTransactionalOpenEvent(messageId : Int,transactionId : String, messageDetails : String) {
        
        var transactionalOpenEventHttpRequest = TransactionalOpenEventHttpRequest()
        transactionalOpenEventHttpRequest.integrationId = _settings.getDengageIntegrationKey()
        transactionalOpenEventHttpRequest.messageId = messageId
        transactionalOpenEventHttpRequest.transactionId = transactionId
        transactionalOpenEventHttpRequest.messageDetails = messageDetails
        
        _transactionalOpenEventService.PostOpenEvent(transactionalOpenEventHttpRequest: transactionalOpenEventHttpRequest)
        
        if _settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
