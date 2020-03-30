//
//  DengageSetter.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation

extension Dengage {
    
    //    MARK:-
    //    MARK:- Setters
    /// Sets Dengage Integration Key
    ///
    ///- Important: This method is required to be filled with key.
    ///
    ///- Usage:
    ///
    ///       Dengage.setDengageIntegrationKey(key: "XzhasowHYg73....")
    ///
    /// - Parameter key : **integrationkey**
    @available(*, renamed: "setDengageIntegrationKey")
    public static func setIntegrationKey(key: String){
        
        _settings.setDengageIntegrationKey(integrationKey: key)
    }
    
    /// Sets Contact Key. Contact key can be your memberId, email of member who has logged in to the application.
    ///
    ///
    /// - Usage:
    ///
    ///     Dengage.setContactKey(contactKey: "adamsmith@acme.com")
    ///
    ///- Parameter contactKey : **contactKey**
    public static func setContactKey(contactKey : String?){
        
        _settings.setContactKey(contactKey: contactKey)
    }
    
    /// Sets Apns Token
    ///
    /// - Precondition: If you want to set Token anywhere in application without using sdk, use this method.
    ///
    /// Usage:
    ///
    ///         Dengage.setToken(token: "")
    ///
    /// - Parameter token : **token**
    public static func setToken(token: String){
        
        _settings.setToken(token: token)
    }
    
    /// Sets  User Permission manually
    ///
    /// - Precondition: if you don't use Dengage.promptForPushNotifications() method, you need to set user permission manually.
    ///
    /// - Usage:
    ///
    ///      Dengage.setUserPermission(permission: true)
    ///
    /// - Parameter permission : **permission**
    public static func setUserPermission(permission : Bool){
        
        _settings.setPermission(permission: permission)
    }
    
    /// Set  Log Status if you want to display logs
    /// Usage:
    ///
    ///     Dengage.setLogStatus(isVisible : true)
    ///
    /// - Parameter isVisible : **isVisible**
    public static func setLogStatus(isVisible : Bool){
        
        _logger.setIsDisabled(isDisabled: isVisible)
    }
    
    /// Dengage generates its own unique device id. Returns Dengage unique device id.
    /// Usage:
    ///
    ///     Dengage.getDeviceId()
    ///
    /// - Returns: **GUID**
    public static func getDeviceId() -> String? {
        
        return _settings.getApplicationIdentifier()
    }
    
    /// Redirects all event endpoints to Cloud Services
    /// Usage:
    ///
    ///     Dengage.useCloudForSubscription(enable : true)
    ///
    /// - Parameter enable : **enable**
    public static func useCloudForSubscription(enable : Bool){
        
        _settings.setCloudEnabled(status: enable)
    }
    
    /// Set test group key for A/B testing.
    /// Usage :
    ///
    ///     Dengage.setTestGroup(testGroup : "some test group")
    ///
    /// - Parameter testGroup : **testGroup**
    public static func setTestGroup(testGroup : String){
        
        _settings.setTestGroup(testGroup: testGroup)
    }
    
    
}
