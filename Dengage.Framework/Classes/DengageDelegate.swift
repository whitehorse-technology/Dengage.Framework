//
//  DengageDelegate.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 23.08.2020.
//

import Foundation

public protocol DengageDelegate {
    func didReceiveNotificationExtentionRequest(receivedRequest: UNNotificationRequest, withNotificationContent: UNMutableNotificationContent)
}
