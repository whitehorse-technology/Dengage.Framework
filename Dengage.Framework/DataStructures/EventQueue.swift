//
//  EventQueue.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 19.12.2019.
//

import Foundation


struct EventQueue {
    
    var items : [EventCollectionModel] = []
    
    mutating func enqueue(element: EventCollectionModel)
    {
        items.append(element)
    }
    
    mutating func dequeue() -> EventCollectionModel?
    {
        
        if items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
    }
}


struct DengageEventQueue {
    
    var items : [NSMutableDictionary] = []
    
    mutating func enqueue(element: NSMutableDictionary)
    {
        items.append(element)
    }
    
    mutating func dequeue() -> NSMutableDictionary?
    {
        
        if items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
    }
}
