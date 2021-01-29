//
//  DeleteMessagesRequest.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 10.01.2021.
//

import Foundation

struct DeleteMessagesRequest: APIRequest{
    
    typealias Response = Bool

    let method: HTTPMethod = .get
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/pi/setAsDeleted"

    let httpBody: Data? = nil
    
    var queryParameters: [URLQueryItem] {
        [
            URLQueryItem(name: "acc", value: accountName),
            URLQueryItem(name: "cdkey", value: contactKey),
            URLQueryItem(name: "msgid", value: id)
        ]
    }

    let id: String
    let contactKey: String
    let accountName: String
    
    init(accountName:String, contactKey: String, id: String) {
        self.accountName = accountName
        self.contactKey = contactKey
        self.id = id
    }
    
}

