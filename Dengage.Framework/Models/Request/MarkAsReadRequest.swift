//
//  MarkAsReadRequest.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 10.01.2021.
//

import Foundation

struct MarkAsReadRequest: APIRequest{
    
    typealias Response = Bool

    let method: HTTPMethod = .get
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/pi/setAsClicked"

    let httpBody: Data? = nil
    
    var queryParameters: [URLQueryItem] {
        [
            URLQueryItem(name: "acc", value: "account_NAME"), // todo
            URLQueryItem(name: "cdkey", value: contactKey),
            URLQueryItem(name: "msgid", value: id)
        ]
    }

    let id: String
    let contactKey: String

    init(contactKey: String, id: String) {
        self.contactKey = contactKey
        self.id = id
    }
    
}
