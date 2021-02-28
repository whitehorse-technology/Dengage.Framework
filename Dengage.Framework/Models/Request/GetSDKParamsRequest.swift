//
//  GetSDKParamsRequest.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 29.01.2021.
//

import Foundation

struct GetSDKParamsRequest: APIRequest {

    typealias Response = GetSDKParamsResponse

    let method: HTTPMethod = .get
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/getSdkParams"

    let httpBody: Data? = nil

    var queryParameters: [URLQueryItem] {
        [
            URLQueryItem(name: "ik", value: integrationKey),
            URLQueryItem(name: "did", value: deviceId)
        ]
    }

    let integrationKey: String
    let deviceId: String

    init(integrationKey: String, deviceId: String) {
        self.integrationKey = integrationKey
        self.deviceId = deviceId
    }
}
