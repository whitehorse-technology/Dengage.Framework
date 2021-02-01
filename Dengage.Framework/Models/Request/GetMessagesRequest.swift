//
//  GetMessagesRequest.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 10.01.2021.
//

import Foundation

struct GetMessagesRequest: APIRequest {

    typealias Response = [DengageMessage]

    let method: HTTPMethod = .get
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/pi/getMessages"

    let httpBody: Data? = nil

    var queryParameters: [URLQueryItem] {
        [
            URLQueryItem(name: "acc", value: accountName),
            URLQueryItem(name: "cdkey", value: contactKey),
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: offset),
            URLQueryItem(name: "type", value: offset)
        ]
    }

    let limit: String
    let offset: String
    let contactKey: String
    let accountName:String
    let type:String
    
    init(accountName:String, contactKey: String, type:String, offset: Int, limit: Int = 20) {
        self.accountName = accountName
        self.contactKey = contactKey
        self.offset = String(offset)
        self.limit = String(limit)
        self.type = type
    }
}


