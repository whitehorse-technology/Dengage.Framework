//
//  EventHttpRequest.swift
//  dengage.ios.sdk
//
//  Created by Developer on 21.10.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation

internal struct EventCollectionHttpRequest {

    public init() {}

    public var integrationKey: String = ""
    public var key: String = ""
    public var eventTable: String = ""
    public var eventDetails: NSDictionary?
}
