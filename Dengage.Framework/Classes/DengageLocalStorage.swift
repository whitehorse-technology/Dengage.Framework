//
//  DengageLocalStorage.swift
//  dengage.ios.sdk
//
//  Created by Developer on 26.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log

internal class DengageLocalStorage: NSObject {
    
    static let shared = DengageLocalStorage(suitName: SUIT_NAME)
    
    var userDefaults: UserDefaults
    
    var inboxUserDefaults: UserDefaults?{
        guard let suitName = INBOX_SUIT_NAME else {return nil}
        return UserDefaults(suiteName: suitName)
    }
    
    init(suitName: String) {
        userDefaults = UserDefaults(suiteName: suitName)!
    }
    
    internal func set(value: Any?, for key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    internal func getValue(key: Key) -> String? {
        guard let value = userDefaults.string(forKey: key.rawValue) else {return nil}
        return value
    }
    
    internal func getValue(for key: Key) -> Any? {
        return userDefaults.object(forKey: key.rawValue)
    }
}

extension DengageLocalStorage{
    func getConfig() -> GetSDKParamsResponse? {
        guard let savedMessageData = userDefaults.object(forKey: Key.configParams.rawValue) as? Data else { return nil }
        let decoder = JSONDecoder()
        do {
            let config = try decoder.decode(GetSDKParamsResponse.self, from: savedMessageData)
            return config
        } catch {
            os_log("[DENGAGE] getInboxMessage fail", log: .default, type: .debug)
            return nil
        }
    }
    
    func saveConfig(with response: GetSDKParamsResponse) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(response)
            userDefaults.setValue(encoded, forKey: Key.configParams.rawValue)
            userDefaults.synchronize()
        } catch {
            os_log("[DENGAGE] saving inbox message fail", log: .default, type: .debug)
        }
    }
}
extension DengageLocalStorage{
    
    enum Key: String{
        case applicationIdentifier = "ApplicationIdentifier"
        case contactKey = "ContactKey"
        case token = "Token"
        case campDate = "dn_camp_date"
        case userPermission = "userPermission"
        case inboxMessages = "inboxMessages"
        case configParams = "configParams"
        case lastFetchedConfigTime = "lastFetchedConfigTime"
    }
}
