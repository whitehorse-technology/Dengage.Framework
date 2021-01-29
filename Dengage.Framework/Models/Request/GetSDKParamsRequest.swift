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
            URLQueryItem(name: "ik", value: integrationKey)
        ]
    }

    let integrationKey: String


    init(integrationKey: String) {
        self.integrationKey = integrationKey
    }
}
