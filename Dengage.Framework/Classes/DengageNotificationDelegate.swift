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
import SafariServices
import UIKit

class DengageNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    let _openEventService : OpenEventService!
    let _transactionalOpenEventService : TransactioanlOpenEventService!
    let _settings : Settings!
    let _logger : SDKLogger = .shared
    
    var openTriggerCompletionHandler: ((_ notificationResponse: UNNotificationResponse)-> Void)?
    
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
    final func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    @available(iOS 10.0, *)
    final func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let content = response.notification.request.content;
        let actionIdentifier = response.actionIdentifier
        
        switch actionIdentifier
        {
            case UNNotificationDismissActionIdentifier:
                os_log("UNNotificationDismissActionIdentifier TRIGGERED", log: .default, type: .info)
                sendEventWithContent(content: content, actionIdentifier: "DismissAction")
            case UNNotificationDefaultActionIdentifier:
                os_log("UNNotificationDefaultActionIdentifier TRIGGERED", log: .default, type: .info)
                sendEventWithContent(content: content, actionIdentifier: "")
            default:
                os_log("ACTION_ID: %s TRIGGERED", log: .default, type:.debug, actionIdentifier)
                sendEventWithContent(content: content, actionIdentifier: actionIdentifier)
                checkTargetUrlInActionButtons(content: content, actionIdentifier: actionIdentifier)
        }
        
        openTriggerCompletionHandler?(response)
        checkTargetUrl(content: content)
        ParseCampIdAndSendId(content: content)
        DengageCustomEvent.shared.SessionStart(referrer: content.userInfo["targetUrl"] as? String ?? "")
        completionHandler()
    }
    
    final func ParseCampIdAndSendId(content : UNNotificationContent){
        let campId = String(content.userInfo["dengageCampId"] as! Int)
        let sendId = String(content.userInfo["dengageSendId"] as! Int)
        
        if !campId.isEmpty {
            _settings.setCampId(campId: campId)
        }
        
        if !sendId.isEmpty {
            _settings.setSendId(sendId: sendId)
        }
    }
    
    final func openDeeplink(link: String?){
        
        if link != nil
        {
            os_log("TARGET_URL is %s", log: .default, type: .debug, link!)
            
            UIApplication.shared.open(URL(string: link!)!, options: [:] , completionHandler: nil);
        }
    }
    
    final func checkTargetUrl(content: UNNotificationContent){
        
        let targetUrl = content.userInfo["targetUrl"] as? String;
        
        if targetUrl?.isEmpty == false{
            openDeeplink(link: targetUrl)
        }
    }
    
    final func checkTargetUrlInActionButtons(content: UNNotificationContent, actionIdentifier : String){
        
        let actionButtons = content.userInfo["actionButtons"]
        
        if actionButtons == nil{
            return
        }
        
        let actionButtonArray = actionButtons  as! NSArray
        
        for item in actionButtonArray
        {
            let dic = item as! NSDictionary
            let id = dic.value(forKey: "id") as! String
            
            if id == actionIdentifier {
                
                let link = dic.value(forKey: "targetUrl") as? String
                
                if link?.isEmpty == false {
                    os_log("Action Button Target URL IS %s", log: .default, type : .debug, link!)
                    openDeeplink(link: link)
                }
            }
        }
    }
    
    
    final func sendEventWithContent(content:UNNotificationContent, actionIdentifier: String?){
        
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
        else{
            return;
        }
        
        if actionIdentifier?.isEmpty == false{
            os_log("BUTTON_ID is %s", log: .default, type: .debug, actionIdentifier!)
        }
        
        var transactionId = ""
        if(content.userInfo["transactionId"] != nil){
            transactionId = content.userInfo["transactionId"] as! String;
            os_log("TRANSACTION_ID is %s", log: .default, type: .debug, transactionId)
            sendTransactionalOpenEvent(messageId: messageId, transactionId: transactionId, messageDetails: messageDetails, buttonId: actionIdentifier)
        }else{
            sendOpenEvent(messageId: messageId, messageDetails: messageDetails, buttonId: actionIdentifier)
        }
    }
    
    
    final func sendOpenEvent(messageId : Int, messageDetails : String, buttonId : String?) {
        
        var openEventHttpRequest = OpenEventHttpRequest()
        openEventHttpRequest.messageId = messageId
        openEventHttpRequest.messageDetails = messageDetails
        openEventHttpRequest.integrationKey = _settings.getDengageIntegrationKey()
        openEventHttpRequest.buttonId = buttonId ?? ""
        
        
        _openEventService.PostOpenEvent(openEventHttpRequest: openEventHttpRequest)
        if _settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
    
    
    final func sendTransactionalOpenEvent(messageId : Int,transactionId : String, messageDetails : String, buttonId : String?) {
        
        var transactionalOpenEventHttpRequest = TransactionalOpenEventHttpRequest()
        transactionalOpenEventHttpRequest.integrationId = _settings.getDengageIntegrationKey()
        transactionalOpenEventHttpRequest.messageId = messageId
        transactionalOpenEventHttpRequest.transactionId = transactionId
        transactionalOpenEventHttpRequest.messageDetails = messageDetails
        transactionalOpenEventHttpRequest.buttonId =  buttonId ?? ""
        
        _transactionalOpenEventService.PostOpenEvent(transactionalOpenEventHttpRequest: transactionalOpenEventHttpRequest)
        
        if _settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
