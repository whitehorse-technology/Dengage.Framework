//
//  Constants.swift
//  dengage.ios.sdk
//
//  Created by Ekin Bulut on 2.12.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation

// MARK:- SERVICE URLS
let SUBSCRIPTION_SERVICE_URL = "https://push.dengage.com/api/device/subscription"
let OPEN_EVENT_SERVICE_URL = "https://push.dengage.com/api/mobile/open"
let TRANSACTIONAL_OPEN_SERVICE_URL = "https://push.dengage.com/api/transactional/mobile/open"
let EVENT_SERVICE_URL = "https://event.dengage.com/api/event"

// MARK:- SETTINGS
let SDK_VERSION = "2.2.3"
let SUIT_NAME = "group.dengage"

let DEFAULT_CARRIER_ID = "1"
let MESSAGE_SOURCE = "DENGAGE"

// MARK:- QUEUE PARAMETERS
let DEVICE_EVENT_QUEUE = "device-event-queue"
let SUBSCRIPTION_QUEUE = "subscription-queue"
let QUEUE_LIMIT = 5

// MARK:- ACTION TYPES AND CATEGORIES
let YES_ACTION = "YES_ACTION"
let NO_ACTION = "NO_ACTION"

let ACCEPT_ACTION = "ACCEPT_ACTION"
let DECLINE_ACTION = "DECLINE_ACTION"

let CONFIRM_ACTION = "CONFIRM_ACTION"
let CANCEL_ACTION = "CANCEL_ACTION"

let SIMPLE_CATEGORY = "DENGAGE_SIMPLE_CATEGORY"
let ASK_CATEGORY = "DENGAGE_ASK_CATEGORY"
let CONFIRM_CATEGORY = "DENGAGE_CONFIRM_CATEGORY"
