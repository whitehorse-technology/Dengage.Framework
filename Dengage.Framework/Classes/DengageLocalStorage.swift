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
    
    var inboxUserDefaults: UserDefaults{
        return UserDefaults(suiteName: INBOX_SUIT_NAME)!
    }
    
    init(suitName: String) {
        userDefaults = UserDefaults.init(suiteName: suitName)!
    }
    
    internal func setValueWithKey(value: String, key: String) {
        
        userDefaults.set(value, forKey: key)
    }
    
    internal func getValueWithKey(key: String) -> String? {
        
        if userDefaults.object(forKey: key) != nil {
            
            let returnValue = userDefaults.string(forKey: key)!
            
            return returnValue
        }
        
        return nil
    }
    
    internal func setValueWithKey(value: Any?, key: String) {
        
        userDefaults.set(value, forKey: key)
    }
    
    internal func getValueWithKeyWith(key: String) -> Any? {
        
        if userDefaults.object(forKey: key) != nil {
            
            let returnValue = userDefaults.object(forKey: key)!
            
            return returnValue
        }
        
        return nil
    }
}


extension DengageLocalStorage {
    func getInboxMessages() -> [DengageMessage]{
        guard let savedMessageData = inboxUserDefaults.object(forKey: "DengageInboxMessages") as? Data else { return [] }
        let decoder = JSONDecoder()
        do {
            let messages = try decoder.decode([DengageMessage].self, from: savedMessageData)
            return messages
        } catch {
            os_log("[DENGAGE] getInboxMessage fail", log: .default, type: .debug)
            return []
        }
    }
    
    func saveMessages(with messages: [DengageMessage]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(messages)
            inboxUserDefaults.setValue(encoded, forKey: "DengageInboxMessages")
            inboxUserDefaults.synchronize()
        } catch {
            os_log("[DENGAGE] saving inbox message fail", log: .default, type: .debug)
        }
    }
}
