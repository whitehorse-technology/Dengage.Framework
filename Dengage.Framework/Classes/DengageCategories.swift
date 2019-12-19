//
//  DengageCategories.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 17.12.2019.
//

import Foundation
import UserNotifications

class DengageCategories {
    
    private let _notificationCenter : UNUserNotificationCenter!
    
    init() {
        _notificationCenter = UNUserNotificationCenter.current()
    }
    
    init(notificationCenter : UNUserNotificationCenter = .current()){
        
        _notificationCenter = notificationCenter
    }
    
    internal func registerCategories(){
        
        let dengageDefaultCategories = getCategories()
        
        _notificationCenter.setNotificationCategories(dengageDefaultCategories)
        
    }
    
    internal func registerCustomCategories(identifier: String, actions : [String: String]){
        
        var actionsArr : [UNNotificationAction] = []
        
        for action in actions {
            
            
            actionsArr.append(UNNotificationAction(identifier: action.key, title: action.value, options:UNNotificationActionOptions(rawValue: 0) ))
            
        }
        
        let customCategory = UNNotificationCategory(identifier: identifier, actions: actionsArr, intentIdentifiers: [], options: .customDismissAction)
        
        _notificationCenter.setNotificationCategories([customCategory])
    }
    
    
    private func getCategories() -> Set<UNNotificationCategory> {
        
        var notificationCategories : Set<UNNotificationCategory> = .init()
        
        let defaultCategories = initializeDefaultCategories()
        
        for categories in defaultCategories
        {
            let category = createCategory(identifier: categories.identifier, actions: categories.actions)
            notificationCategories.insert(category)
        }
        
        return notificationCategories
    }
    
    private func createCategory(identifier : String, actions: [String:String]) -> UNNotificationCategory {
        
        var actionsArr : [UNNotificationAction] = []
        
        for action in actions {
            
            
            actionsArr.append(UNNotificationAction(identifier: action.key, title: action.value, options:.foreground))
            
        }
        
        let customCategory = UNNotificationCategory(identifier: identifier, actions: actionsArr, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        
        return customCategory
    }
    
    private func initializeDefaultCategories() -> [DefaultCategory] {
        
        var defaultCategories : [DefaultCategory] = []
        
        let simpleCategory : DefaultCategory = .init()
        simpleCategory.identifier = SIMPLE_CATEGORY
        simpleCategory.actions = [ACCEPT_ACTION:"Accept", DECLINE_ACTION: "Decline"]
        
        let askingCategory : DefaultCategory = .init()
        askingCategory.identifier = ASK_CATEGORY
        askingCategory.actions = [YES_ACTION:"Yes", NO_ACTION : "No"]
        
        let confirmCategory : DefaultCategory = .init()
        confirmCategory.identifier = CONFIRM_CATEGORY
        confirmCategory.actions = [CONFIRM_ACTION:"Confirm", CANCEL_ACTION : "Cancel"]
        
        defaultCategories.append(simpleCategory)
        defaultCategories.append(askingCategory)
        defaultCategories.append(confirmCategory)
        
        return defaultCategories
        
    }
    
}
