//
//  DengageCategories.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 17.12.2019.
//

import Foundation
import UserNotifications

class DengageCategories {
    
    private let _notificationCenter : UNUserNotificationCenter!
    
    init() {
        _notificationCenter = UNUserNotificationCenter.current()
    }
    
    init(notificationCenter : UNUserNotificationCenter = .current()){
        
        _notificationCenter = notificationCenter
    }
    
    internal func registerCategories(){
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                                                title: "Accept",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
                                                 title: "Decline",
                                                 options: UNNotificationActionOptions(rawValue: 0))
        
        let defaultSimpleCategory =
            UNNotificationCategory(identifier: "DENGAGE_SIMPLE_CATEGORY",
                                   actions: [acceptAction, declineAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        
        _notificationCenter.setNotificationCategories([defaultSimpleCategory])
        
    }
    
}
