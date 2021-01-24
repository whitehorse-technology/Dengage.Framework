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
        let dataContainer = try decoder.container(keyedBy: CodingKeys.DataContainer.self)
        let dataValueContainer = try dataContainer.nestedContainer(
            keyedBy: CodingKeys.DataContainer.DataValueContainer.self,
            forKey: .dataContainer
        )
        title = try dataValueContainer.decode(String.self, forKey: .title)
        message = try dataValueContainer.decode(String.self, forKey: .message)
        mediaURL = try dataValueContainer.decode(String.self, forKey: .mediaUrl)
        targetURL = try dataValueContainer.decode(String.self, forKey: .targetUrl)
        let receiveDateString = try dataValueContainer.decode(String.self, forKey: .receiveDate)
        self.receiveDate = DengageMessage.convertDate(to: receiveDateString)

    }
    enum CodingKeys: String, CodingKey {

        enum DataContainer: String, CodingKey {
            case dataContainer = "data"

            enum DataValueContainer: String, CodingKey {
                case title, message, mediaUrl, targetUrl, receiveDate
            }
        }
        case id, isClicked
    }

    static func convertDate(to date: String?) -> Date? {
        guard let dateString = date else {return nil}
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: dateString)
    }
}
