//
//  DengageDelegates.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 30.03.2020.
//

import Foundation

extension Dengage {
    /// Notification Delegate which returns *UNNotificationResponse*
    /// - Usage:
    /// ```
    /// Dengage.HandleNotificationActionBlock { (notificationResponse) in
    ///
    ///         //read payload
    ///         print("notifiation received from HandleNotificationActionBlock ")
    ///     }
    /// ```
    /// - Parameter callback : *a function which will receive UNNotificationResponse*
    public static func handleNotificationActionBlock(callback: @escaping
        (_ notificationResponse: UNNotificationResponse) -> Void) {
        notificationDelegate.openTriggerCompletionHandler = {
            response in
            callback(response)
        }
    }
    
}
