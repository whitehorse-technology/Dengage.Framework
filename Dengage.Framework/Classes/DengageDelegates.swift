//
//  DengageDelegates.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 30.03.2020.
//

import Foundation



extension Dengage {
    
    /// Notification Delegate which returns *UNNotificationResponse*
    ///
    /// - Usage:
    /// ```
    /// Dengage.HandleNotificationActionBlock { (notificationResponse) in
    ///
    ///         //read payload
    ///         print("notifiation received from HandleNotificationActionBlock ")
    ///     }
    /// ```
    /// - Parameter callback : *a function which will receive UNNotificationResponse*
    public static func HandleNotificationActionBlock(callback: @escaping (_ notificationResponse : UNNotificationResponse)-> ()){
        notificationDelegate.openTriggerCompletionHandler = {
           response in
            callback(response)
        }
    }

}
