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
    /// Set  Integration Key ( Required )
    /// ```
    /// self.setDengageIntegrationKey(key: "...")
    /// ```
    @available(*, renamed: "setDengageIntegrationKey")
    public static func setIntegrationKey(key: String){
        
        _settings.setDengageIntegrationKey(integrationKey: key)
    }
    
    /// Set Contact Key ( Optional )
    /// ```
    /// self.setContactKey(contactKey: "adamsmith@acme.com")
    /// ```
    public static func setContactKey(contactKey : String?){
        
        _settings.setContactKey(contactKey: contactKey)
    }
    
    /// Set Apns Token
    /// ```
    /// self.setToken(token: "")
    /// ```
    public static func setToken(token: String){
        
        _settings.setToken(token: token)
    }
    
    /// Set  User Permission manually
    /// ```
    /// self.setUserPermission(permission: true)
    /// ```
    public static func setUserPermission(permission : Bool){
        
        _settings.setPermission(permission: permission)
    }
    
    /// Set  Log Status if you want to display logs
    /// ```
    /// self.setLogStatus(isVisible: true)
    /// ```
    public static func setLogStatus(isVisible : Bool){
        
        _logger.setIsDisabled(isDisabled: isVisible)
    }
    
    public static func getDeviceId() -> String? {
        
        return _settings.getApplicationIdentifier()
    }
    
    public static func useCloudForSubscription(enable : Bool){
        
        _settings.setCloudEnabled(status: enable)
    }
    
    public static func setTestGroup(testGroup : String){
        
        _settings.setTestGroup(testGroup: testGroup)
    }
    
    
}
