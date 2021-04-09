//
//  DengageSetter.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation

extension Dengage {
    
    //MARK: - Setters
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
    public static func setIntegrationKey(key: String) {
        settings.setDengageIntegrationKey(integrationKey: key)
    }
    
    /// Sets Contact Key. Contact key can be your memberId, email of member who has logged in to the application.
    ///
    ///
    /// - Usage:
    ///
    ///     Dengage.setContactKey(contactKey: "adamsmith@acme.com")
    ///
    ///- Parameter contactKey : **contactKey**
    public static func setContactKey(contactKey: String?) {
        settings.setContactKey(contactKey: contactKey)
    }
    
    /// Returns Contact Key. Contact key can be your memberId, email of member who has logged in to the application.
    ///
    ///
    /// - Usage:
    ///
    ///     Dengage.getContactKey()
    ///
    ///- Parameter contactKey : **contactKey**
    public static func getContactKey() -> String {
       return settings.getContactKey() ?? ""
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
    public static func setToken(token: String) {
        settings.setToken(token: token)
    }
    
    // GetAPNsToken
    public static func getToken() -> String {
        return settings.getToken() ?? ""
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
    public static func setUserPermission(permission: Bool) {
        settings.setPermission(permission: permission)
    }
    
    /// Set  Log Status if you want to display logs
    /// Usage:
    ///
    ///     Dengage.setLogStatus(isVisible : true)
    ///
    /// - Parameter isVisible : **isVisible**
    public static func setLogStatus(isVisible: Bool) {
        logger.setIsDisabled(isDisabled: isVisible)
    }
    
    /// Dengage generates its own unique device id. Returns Dengage unique device id.
    /// Usage:
    ///
    ///     Dengage.getDeviceId()
    ///
    /// - Returns: **GUID**
    public static func getDeviceId() -> String? {
        return settings.getApplicationIdentifier()
    }
        
    /// Set test group key for A/B testing.
    /// Usage :
    ///
    ///     Dengage.setTestGroup(testGroup : "some test group")
    ///
    /// - Parameter testGroup : **testGroup**
    public static func setTestGroup(testGroup: String) {
        settings.setTestGroup(testGroup: testGroup)
    }
    
    /// Referrer is the source address from where application initialize
    /// Example : if application opens up from deeplink referrer can be link source
    /// Usage :
    ///
    ///     Dengage.setReferrer(referrer : "http://sample.com")
    ///
    /// - Parameter referrer : **url address**
    public static func setReferrer(referrer: String) {
        settings.setReferrer(referrer: referrer)
    }
    
    /// ApplicationIdentifier is a unique identifier for user device.
    /// Usage :
    ///
    ///     Dengage.setApplicationIdentifier(applicationIdentifier: "device-id")
    ///
    /// - Parameter applicationIdentifier : unique-device-id
    public static func setDeviceId(applicationIdentifier: String) {
        settings.setApplicationIdentifier(applicationIndentifier: applicationIdentifier)
    }
    
    /// App group name  is a func which sets notfication extension groupname
    /// Usage :
    ///
    ///     Dengage.setAppGroupName(with: "group.dengage.example")
    ///
    /// - Parameter appGroupName : app group name
    public static func setAppGroupName(with name: String) {
        INBOX_SUIT_NAME = name
    }
}
