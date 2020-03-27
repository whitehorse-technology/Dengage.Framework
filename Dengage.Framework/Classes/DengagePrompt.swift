//
//  DengagePrompt.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {
    
    // MARK:- Prompt Methods
    
    /// Handles  notification permission
    /// Sends subscription request
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
    
    static func getNotificationSettings() {
        
        center.getNotificationSettings { settings in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async{
                
                _logger.Log(message: "REGISTER_TOKEN", logtype: .debug)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}
