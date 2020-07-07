//
//  DengagePrompt.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {
    
    
    
    
    // MARK:- Prompt Methods
    
    /// Enables or Disables SDK for remote notification registration
    ///
    ///      Dengage.registerForRemoteNotifications(enable : false)
    ///
    /// - Parameter enable : enables UIApplication.shared.registerForRemoteNotifications() method
    public static func registerForRemoteNotifications(enable : Bool) {
        
        _settings.setRegiterForRemoteNotification(enable: enable)
    }
    
    /// Asks notification permission to user.
    ///
    /// - Warning:
    ///
    ///     Calls UNUserNotificationCenter.current().requestAuthorization method.
    ///
    public static func promptForPushNotifications()
    {
        let queue = DispatchQueue(label: SUBSCRIPTION_QUEUE, qos: .userInitiated)
        
        center
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [self] granted, error in
                
                IsUserGranted = granted
                
                guard granted else
                {
                    _logger.Log(message: "PERMISSION_NOT_GRANTED %s", logtype: .debug, argument: String(granted))
                    _settings.setPermission(permission: IsUserGranted)
                    
                    queue.async {
                        Dengage.SyncSubscription()
                    }
                    return
                }
                
                _settings.setPermission(permission: IsUserGranted)
                self.getNotificationSettings()
                
                
                _logger.Log(message: "PERMISSION_GRANTED %s", logtype: .debug, argument: String(granted))
                queue.async {
                    Dengage.SyncSubscription()
                }
                
        }
    }
    
    //// Asks notification permission to user.
    ///
    /// - Warning:
    ///
    ///     Calls UNUserNotificationCenter.current().requestAuthorization method.
    ///
    /// - Parameter callback: IsUserGranted
    public static func promptForPushNotifications(callback: @escaping (_ IsUserGranted : Bool)-> ())
    {
        
        center
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [self] granted, error in
                
                IsUserGranted = granted
                
                guard granted else
                {
                    _logger.Log(message: "PERMISSION_NOT_GRANTED %s", logtype: .debug, argument: String(granted))
                    _settings.setPermission(permission: IsUserGranted)

                    Dengage.SyncSubscription()
                    
                    callback(IsUserGranted)
                    return
                }
                
                _settings.setPermission(permission: IsUserGranted)
                self.getNotificationSettings()
                callback(IsUserGranted)
                _logger.Log(message: "PERMISSION_GRANTED %s", logtype: .debug, argument: String(granted))
        }
    }
    
    static func getNotificationSettings() {
        
        let registerForRemoteNotification = _settings.getRegiterForRemoteNotification()
        
        if registerForRemoteNotification {
            
            center.getNotificationSettings { settings in
                
                guard settings.authorizationStatus == .authorized else { return }
                
                DispatchQueue.main.async{
                    
                    _logger.Log(message: "REGISTER_TOKEN", logtype: .debug)
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } 
    }
}
