//
//  GetMessagesRequest.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 10.01.2021.
//

import Foundation

struct GetMessagesRequest: APIRequest {

    typealias Response = GetMessagesResponse

    let method: HTTPMethod = .get
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/pi/getMessages"

    let httpBody: Data? = nil

    var queryParameters: [URLQueryItem] {
        [
            URLQueryItem(name: "acc", value: "account_NAME"), //todo
            URLQueryItem(name: "cdkey", value: contactKey),
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: offset)
        ]
    }

    let limit: String
    let offset: String
    let contactKey: String
    let accountName:String
    init(accountName:String, contactKey: String, offset: Int, limit: Int = 20) {
        self.accountName = accountName
        self.contactKey = contactKey
        self.offset = String(offset)
        self.limit = String(limit)
    }
}

struct GetMessagesResponse: Decodable {
    let messages: [DengageMessage]
}
