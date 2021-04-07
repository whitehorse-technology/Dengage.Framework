//
//  DengageNotificationExtension.swift
//  dengage.ios.sdk
//
//  Created by Developer on 27.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import UserNotifications

class DengageNotificationExtension {
    
    static let shared = DengageNotificationExtension()

    var logger: SDKLogger
    
    var bestAttemptContent: UNMutableNotificationContent?
    var userNotificationCenter: UNUserNotificationCenter
    
    init() {
        logger = .shared
        userNotificationCenter = .current()
    }
    
    init(logger: SDKLogger = .shared) {
        self.logger = logger
        userNotificationCenter = .current()
    }
    
    internal func didReceiveNotificationExtentionRequest(receivedRequest: UNNotificationRequest, withNotificationContent: UNMutableNotificationContent){
        
        logger.Log(message: "NOTIFICATION_RECEIVED", logtype: .info)
        let messageSource = receivedRequest.content.userInfo["messageSource"]
        
        if messageSource != nil {
            
            if MESSAGE_SOURCE == messageSource as? String {
                
                let categoryIdentifier = withNotificationContent.categoryIdentifier
                
                //parse message and if there are any action buttons on payload register them to notification center
                registerForActionButtons(receivedRequest: receivedRequest, categoryIdentifier: categoryIdentifier)
                
                self.bestAttemptContent = withNotificationContent
                self.bestAttemptContent?.title = (receivedRequest.content.userInfo["title"] as? String)!
                self.bestAttemptContent?.subtitle = (receivedRequest.content.userInfo["subtitle"] as? String)!
                
                var urlString: String?
                if let urlImageString = receivedRequest.content.userInfo["urlImageString"] as? String {
                    urlString = urlImageString
                }

                guard let urlStr = urlString, let contentUrl = URL(string: urlStr) else { return }
                var lastPathComponent = contentUrl.lastPathComponent
                
                if !((lastPathComponent.contains(".jpeg"))
                    || (lastPathComponent.contains(".jpg"))
                    || (lastPathComponent.contains(".gif"))
                    || (lastPathComponent.contains(".mov"))
                    || (lastPathComponent.contains(".mp4"))
                    || (lastPathComponent.contains(".m4v"))) {
                    lastPathComponent.append(contentsOf: ".gif")
                }
   
                guard let imageData = NSData(contentsOf: contentUrl) else {
                        logger.Log(message: "URL_STR_IS_NULL", logtype: .info)
                        return
                    }
                
                guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: lastPathComponent,
                                                                                    data: imageData,
                                                                                    options: nil) else {
                        logger.Log(message: "UNNotificationAttachment.saveImageToDisk()", logtype: .error)
                        return
                    }
                    
                    self.bestAttemptContent?.attachments = [ attachment ]
            }
        }
    }
    
    private func registerForActionButtons(receivedRequest: UNNotificationRequest, categoryIdentifier: String?) {

        let categoryIdentifier = categoryIdentifier ?? "dengage"
        
        let actionButtons = receivedRequest.content.userInfo["actionButtons"]
        
        if actionButtons == nil {
            
            logger.Log(message: "Action Button is nil", logtype: .debug)
            //dengageCategories.registerCategories()
            return
        }
        
        logger.Log(message: "Parsing action buttons", logtype: .debug)
        
        let actionButtonArray = actionButtons  as! NSArray
        
        var actionsArr: [UNNotificationAction] = []
        for item in actionButtonArray {
            let dic = item as! NSDictionary
            let id = dic.value(forKey: "id") as! String
            let text = dic.value(forKey: "text") as! String
            
            let action = UNNotificationAction(identifier: id, title: text, options: .foreground)
            actionsArr.append(action)
        }
        
        let category: UNNotificationCategory;
        if #available(iOS 11.0, *) {
            category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: actionsArr, intentIdentifiers: [],
                                              hiddenPreviewsBodyPlaceholder: "",
                                              options: .customDismissAction)
            
        } else {
            // Fallback on earlier versions
            category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: actionsArr,
                                              intentIdentifiers: [],
                                              options: .customDismissAction)
        }
        
        userNotificationCenter.setNotificationCategories([category])
    }
}

@available(iOSApplicationExtension 10.0, *)
public extension UNNotificationAttachment {
    
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            SDKLogger.shared.Log(message:"ERROR_LOG %s", logtype: .error, argument: error.localizedDescription)
        }
        
        return nil
    }
}
