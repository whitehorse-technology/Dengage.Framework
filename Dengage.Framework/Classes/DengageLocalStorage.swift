//
//  DengageLocalStorage.swift
//  dengage.ios.sdk
//
//  Created by Developer on 26.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log


internal class DengageLocalStorage : NSObject {
    
    static let shared = DengageLocalStorage(suitName: SUIT_NAME)
    
    var _userDefaults = UserDefaults.init()
    
    init(suitName: String){
        _userDefaults = UserDefaults.init(suiteName: suitName)!
    }
    
    internal func setValueWithKey(value: String, key: String){
        
        _userDefaults.set(value, forKey: key);
    }
    
    internal func getValueWithKey(key: String) -> String?{
        
        if _userDefaults.object(forKey: key) != nil{
            
            let returnValue = _userDefaults.string(forKey: key)!

            return returnValue
        }
        
        return nil
    }
}
