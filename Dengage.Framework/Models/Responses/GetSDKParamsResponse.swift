//
//  GetSDKParamsResponse.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 29.01.2021.
//

import Foundation
struct GetSDKParamsResponse: Codable {
    let accountId: Int
    let accountName: String
    let eventsEnabled: Bool
    let inboxEnabled: Bool
    let inAppEnabled: Bool
    let subscriptionEnabled: Bool
}
