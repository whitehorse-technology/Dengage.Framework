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
            URLQueryItem(name: "acc", value: accountName),
            URLQueryItem(name: "cdkey", value: contactKey),
            URLQueryItem(name: "msgid", value: id),
            URLQueryItem(name: "did", value: deviceID),
            URLQueryItem(name: "type", value: type)
        ]
    }
    
    let id: String
    let contactKey: String
    let accountName: String
    let type: String
    let deviceID:String
    
    init(type: String, deviceID:String,
        accountName:String, contactKey: String, id: String) {
        self.accountName = accountName
        self.contactKey = contactKey
        self.id = id
        self.type = type
        self.deviceID = deviceID
    }
    
}
