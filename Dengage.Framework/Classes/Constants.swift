//
//  Constants.swift
//  dengage.ios.sdk
//
//  Created by Ekin Bulut on 2.12.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation


// MARK:- SERVICE URLS
let SUBSCRIPTION_SERVICE_URL = "https://push.dengage.com"
let EVENT_SERVICE_URL = "https://event.dengage.com"


// MARK:- QUEUE PARAMETERS
let DEVICE_EVENT_QUEUE = "device-event-queue"
let SUBSCRIPTION_QUEUE = "subscription-queue"
let QUEUE_LIMIT = 20
let QUEUE_FLUSH_TIME = 180.0

// MARK:- SETTINGS
let SDK_VERSION = "2.5.19"

let SUIT_NAME = "group.dengage"

var INBOX_SUIT_NAME: String?

let DEFAULT_CARRIER_ID = "1"
let MESSAGE_SOURCE = "DENGAGE"

let dn_camp_attribution_duration = 7
