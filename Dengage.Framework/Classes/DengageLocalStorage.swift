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
    
    var userDefaults = UserDefaults.init()
    
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
