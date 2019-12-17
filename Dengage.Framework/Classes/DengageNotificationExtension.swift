//
//  DengageNotificationExtension.swift
//  dengage.ios.sdk
//
//  Created by Ekin Bulut on 27.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation


class DengageNotificationExtension {
    
    static let shared = DengageNotificationExtension()
    
    var _logger : SDKLogger
    
    var bestAttemptContent: UNMutableNotificationContent?
    
    init() {
        _logger = .shared
    }
    
    init(logger: SDKLogger = .shared) {
        _logger = logger
    }
    
    internal func didReceiveNotificationExtentionRequest(receivedRequest : UNNotificationRequest, withNotificationContent : UNMutableNotificationContent){
        
        _logger.Log(message: "NOTIFICATION_RECEIVED", logtype: .info)
        
        let messageSource = receivedRequest.content.userInfo["messageSource"]
        
        if (messageSource != nil) {
            
            if (MESSAGE_SOURCE == messageSource as? String){
                
                self.bestAttemptContent = withNotificationContent
                self.bestAttemptContent?.title = (receivedRequest.content.userInfo["title"] as? String)!
                self.bestAttemptContent?.subtitle = (receivedRequest.content.userInfo["subtitle"] as? String)!
                
                var urlString:String? = nil
                if let urlImageString = receivedRequest.content.userInfo["urlImageString"] as? String {
                    urlString = urlImageString
                }
                
                if urlString != nil, let fileUrl = URL(string: urlString!) {
                    
                    guard let imageData = NSData(contentsOf: fileUrl) else {
                        
                        _logger.Log(message: "URL_STR_IS_NULL", logtype: .info)
                        return
                    }
                    guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "image.gif", data: imageData, options: nil) else {
                        _logger.Log(message: "UNNotificationAttachment.saveImageToDisk()", logtype: .error)
                        return
                    }
                    
                    self.bestAttemptContent?.attachments = [ attachment ]
                }
            }
        }
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
