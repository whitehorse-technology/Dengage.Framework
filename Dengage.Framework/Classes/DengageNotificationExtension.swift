//
//  DengageNotificationExtension.swift
//  dengage.ios.sdk
//
//  Created by Ekin Bulut on 27.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import UserNotifications
import os.log

class DengageNotificationExtension {
    
    static let shared = DengageNotificationExtension()
    
    
    var _logger : SDKLogger
    
    var bestAttemptContent: UNMutableNotificationContent?
    var userNotificationCenter : UNUserNotificationCenter

    
    init() {
        _logger = .shared
        userNotificationCenter = .current()
        
    }
    
    init(logger: SDKLogger = .shared) {
        _logger = logger
        userNotificationCenter = .current()
        
    }
    
    internal func didReceiveNotificationExtentionRequest(receivedRequest : UNNotificationRequest, withNotificationContent : UNMutableNotificationContent){
        
        _logger.Log(message: "NOTIFICATION_RECEIVED", logtype: .info)
        let messageSource = receivedRequest.content.userInfo["messageSource"]
        
        if (messageSource != nil) {
            
            if (MESSAGE_SOURCE == messageSource as? String){
                
                let categoryIdentifier = withNotificationContent.categoryIdentifier
               
                RegisterForActionButtons(receivedRequest: receivedRequest, categoryIdentifier: categoryIdentifier)
                
                self.bestAttemptContent = withNotificationContent
                self.bestAttemptContent?.title = (receivedRequest.content.userInfo["title"] as? String)!
                self.bestAttemptContent?.subtitle = (receivedRequest.content.userInfo["subtitle"] as? String)!
                
                var urlString:String? = nil
                if let urlImageString = receivedRequest.content.userInfo["urlImageString"] as? String {
                    urlString = urlImageString
                }
                
                if((urlString == nil) == true){
                    return
                }
                
                let contentUrl = URL(string: urlString!)
                var lastPathComponent = contentUrl?.lastPathComponent
                
                if !((lastPathComponent?.contains(".jpeg"))!
                    || (lastPathComponent?.contains(".jpg"))!
                    || (lastPathComponent?.contains(".gif"))!
                    || (lastPathComponent?.contains(".mov"))!
                    || (lastPathComponent?.contains(".mp4"))!
                    || (lastPathComponent?.contains(".m4v"))!) {
                    lastPathComponent?.append(contentsOf: ".gif")
                }
                
                if urlString != nil, let fileUrl = contentUrl {
                    
                    guard let imageData = NSData(contentsOf: fileUrl) else {
                        
                        _logger.Log(message: "URL_STR_IS_NULL", logtype: .info)
                        return
                    }
                    guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: lastPathComponent!, data: imageData, options: nil) else {
                        _logger.Log(message: "UNNotificationAttachment.saveImageToDisk()", logtype: .error)
                        return
                    }
                    
                    self.bestAttemptContent?.attachments = [ attachment ]
                    
                }
            }
        }
    }
    
    private func RegisterForActionButtons(receivedRequest : UNNotificationRequest, categoryIdentifier: String?){
       
        let categoryIdentifier = categoryIdentifier ?? "dengage";
        
        let actionButtons = receivedRequest.content.userInfo["actionButtons"];
        
        if actionButtons == nil {
            
            os_log("Action Button is nil")
            //dengageCategories.registerCategories()
            return
        }
        
        os_log("Parsing action buttons")
        
        let actionButtonArray = actionButtons  as! NSArray
        
        var actionsArr : [UNNotificationAction] = []
        for item in actionButtonArray
        {
            let dic = item as! NSDictionary
            let id = dic.value(forKey: "id") as! String
            let text = dic.value(forKey: "text") as! String
            
            let action = UNNotificationAction(identifier: id, title: text, options: .foreground)
            actionsArr.append(action)
            
        }
        
        let category : UNNotificationCategory;
        if #available(iOS 11.0, *) {
            category = UNNotificationCategory(identifier: categoryIdentifier, actions: actionsArr, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)

        } else {
            // Fallback on earlier versions
           category = UNNotificationCategory(identifier: categoryIdentifier, actions: actionsArr, intentIdentifiers: [], options: .customDismissAction)
        }
        
        userNotificationCenter.setNotificationCategories([category])
    }
}

@available(iOSApplicationExtension 10.0, *)
public extension UNNotificationAttachment {
    
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            SDKLogger.shared.Log(message:"ERROR_LOG %s",  logtype: .error, argument: error.localizedDescription)
        }
        
        return nil
    }
}
