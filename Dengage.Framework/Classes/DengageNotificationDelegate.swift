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


class DengageNotificationDelegate: NSObject , UNUserNotificationCenterDelegate {
    
    let openEventService = OpenEventService()
    let transactionalOpenEventService = TransactioanlOpenEventService()
    let settings = Settings.shared
    
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
                os_log("UNNotificationDismissActionIdentifier", log: .default, type: .info)
                print("DENGAGE_INFO_LOG: UNNotificationDismissActionIdentifier TRIGGERED", "")
            case UNNotificationDefaultActionIdentifier:
                os_log("UNNotificationDefaultActionIdentifier TRIGGERED", log: .default, type: .info)
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
        openEventHttpRequest.integrationKey = settings.getDengageIntegrationKey()
        
        openEventService.PostOpenEvent(openEventHttpRequest: openEventHttpRequest)
        if settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
    
    
    func sendTransactionalOpenEvent(messageId : Int,transactionId : String, messageDetails : String) {
        
        var transactionalOpenEventHttpRequest = TransactionalOpenEventHttpRequest()
        transactionalOpenEventHttpRequest.integrationId = settings.getDengageIntegrationKey()
        transactionalOpenEventHttpRequest.messageId = messageId
        transactionalOpenEventHttpRequest.transactionId = transactionId
        transactionalOpenEventHttpRequest.messageDetails = messageDetails
        
        transactionalOpenEventService.PostOpenEvent(transactionalOpenEventHttpRequest: transactionalOpenEventHttpRequest)
        
        if settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
