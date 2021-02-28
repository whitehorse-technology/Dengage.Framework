//
//  DengageMessage.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 30.11.2020.
//

import Foundation

public struct DengageMessage: Codable {

    public let id: String
    public let title: String?
    public let message: String?
    public let mediaURL: String?
    public let targetURL: String?
    public let receiveDate: Date?
    public var isClicked: Bool

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        isClicked = try container.decode(Bool.self, forKey: .isClicked)
        let messageJson = try container.decode(String.self, forKey: .message)
        let data = Data(messageJson.utf8)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        self.title = json["title"] as? String
        self.message = json["message"] as? String
        self.mediaURL = json["mediaUrl"] as? String
        self.targetURL = json["targetUrl"] as? String
        let receiveDateString = json["receiveDate"] as! String
        self.receiveDate = DengageMessage.convertDate(to: receiveDateString)
        
    }
    enum CodingKeys: String, CodingKey {
        case id = "smsg_id", isClicked = "is_clicked", message = "message_json"
    }

    static func convertDate(to date: String?) -> Date? {
        guard let dateString = date else {return nil}
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: dateString)
    }
}


