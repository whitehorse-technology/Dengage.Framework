//
//  Constants.swift
//  dengage.ios.sdk
//
//  Created by Ekin Bulut on 2.12.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation


// MARK:- SERVICE URLS
var SUBSCRIPTION_SERVICE_URL = "https://push.dengage.com"
var EVENT_SERVICE_URL = "https://event.dengage.com"
var GEOFENCE_SERVICE_URL = "https://geofence.dengage.com"

// MARK:- QUEUE PARAMETERS
let DEVICE_EVENT_QUEUE = "device-event-queue"
let SUBSCRIPTION_QUEUE = "subscription-queue"
let QUEUE_LIMIT = 5

// MARK:- SETTINGS
let SDK_VERSION = "4.1.2"
let SUIT_NAME = "group.dengage"
let DEFAULT_CARRIER_ID = "1"
let MESSAGE_SOURCE = "DENGAGE"

let dn_camp_attribution_duration = 7

let GEOFENCE_MAX_MONITOR_COUNT = 20
let GEOFENCE_MAX_FETCH_INTERVAL = TimeInterval(15 * 60)
let GEOFENCE_MAX_EVENT_SIGNAL_INTERVAL = TimeInterval(5 * 60)
let GEOFENCE_FETCH_HISTORY_MAX_COUNT = 100
let GEOFENCE_EVENT_HISTORY_MAX_COUNT = 100
