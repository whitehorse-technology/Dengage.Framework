//
//  DengageMessage.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 30.11.2020.
//

import Foundation

public struct DengageMessage: Codable{
    
    public let id: String
    public let title: String?
    public let message: String?
    public let mediaURL: String?
    public let targetURL: String?
    public let receiveDate: Date?
    public let expireDate: Date?
    public var isRead: Bool
    
    init?(with notification: UNNotificationContent){
        let source = notification.userInfo
        guard let addToInbox = source["addToInbox"] as? Bool, addToInbox else { return nil }
        guard let messageId =  notification.dengageMessageId else {return nil}
        self.id = messageId
        self.title = source["title"] as? String
        self.message = source["subtitle"] as? String
        self.mediaURL = source["urlImageString"] as? String
        self.targetURL = source["targetUrl"] as? String
        self.receiveDate = Date()
        let expireDateString = source["expireDate"] as? String
        self.expireDate = DengageMessage.convertDate(to: expireDateString)
        self.isRead = false
    }
    
    static func convertDate(to date:String?) -> Date? {
        guard let dateString = date else {return nil}
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: dateString)
    }
}

