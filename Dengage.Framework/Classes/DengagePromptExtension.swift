//
//  DengagePrompt.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {
    
    static var isUserGranted: Bool = false
    // MARK: - Prompt Methods
    
    /// Enables or Disables SDK for remote notification registration
    ///
    ///      Dengage.registerForRemoteNotifications(enable: false)
    ///
    /// - Parameter enable : enables UIApplication.shared.registerForRemoteNotifications() method
    public static func registerForRemoteNotifications(enable: Bool) {
        settings.setRegiterForRemoteNotification(enable: enable)
    }
    
    /// Asks notification permission to user.
    ///
    /// - Warning:
    ///
    ///     Calls UNUserNotificationCenter.current().requestAuthorization method.
    ///
    public static func promptForPushNotifications() {
        center
            .requestAuthorization(options: [.alert, .sound, .badge]) { [self] granted, _ in
                
                isUserGranted = granted
                
                guard granted else {
                    logger.Log(message: "PERMISSION_NOT_GRANTED %s", logtype: .debug, argument: String(granted))
                    settings.setPermission(permission: isUserGranted)
                    
                    Dengage.SyncSubscription()
                    
                    return
                }
                
                settings.setPermission(permission: isUserGranted)
                self.getNotificationSettings()
                logger.Log(message: "PERMISSION_GRANTED %s", logtype: .debug, argument: String(granted))    
        }
    }
    
    //// Asks notification permission to user.
    ///
    /// - Warning:
    ///
    ///     Calls UNUserNotificationCenter.current().requestAuthorization method.
    ///
    /// - Parameter callback: IsUserGranted
    public static func promptForPushNotifications(callback: @escaping (_ IsUserGranted: Bool) -> Void) {
       
        center
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [self] granted, error in
                
                isUserGranted = granted
                
                guard granted else {
                    logger.Log(message: "PERMISSION_NOT_GRANTED %s", logtype: .debug, argument: String(granted))
                    settings.setPermission(permission: isUserGranted)
                    
                    Dengage.SyncSubscription()
                    callback(isUserGranted)
                    return
                }
                
                settings.setPermission(permission: isUserGranted)
                self.getNotificationSettings()
                logger.Log(message: "PERMISSION_GRANTED %s", logtype: .debug, argument: String(granted))
                callback(isUserGranted)
        }
    }
    
    static func getNotificationSettings() {
        
        let registerForRemoteNotification = settings.getRegiterForRemoteNotification()
        
        if registerForRemoteNotification {
            
            center.getNotificationSettings { settings in
                
                guard settings.authorizationStatus == .authorized else { return }
                
                DispatchQueue.main.async {

                    logger.Log(message: "REGISTER_TOKEN", logtype: .debug)
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } 
    }
}
