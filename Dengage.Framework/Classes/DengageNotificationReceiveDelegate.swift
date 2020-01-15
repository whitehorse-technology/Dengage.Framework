//
//  DengageNotificationReceiveDelegate.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 23.12.2019.
//

import Foundation


protocol DengageNotificationReceiveDelegate {
    
    func DengageReceivedPayload(receivedRequest : UNNotificationRequest)
}
