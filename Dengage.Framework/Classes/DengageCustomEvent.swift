//
//  DengageCustomEvent.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 30.05.2020.
//

import Foundation

public class DengageCustomEvent{
    
    
    var _settings : Settings = .shared
    var _eventCollectionService : EventCollectionService = EventCollectionService()
    var _utilities : Utilities = .shared
    var _sessionManager : SessionManager = .shared
    
    public static let shared  = DengageCustomEvent()
    
    ///Before sending an event Dengage.Framework opens  a Session by defualt.
    ///But according to implementation, developer can able to open a session manually.
    ///
    ///- Parameter location : *deeplinkUrl*
    public func SessionStart(location : String){
        
        
        if _settings.getSessionStart() {
            
            return
        }
        
        let session = _sessionManager.getSession()
        
        _settings.setSessionId(sessionId: session.Id)
        
        let deviceId = _settings.getApplicationIdentifier()
        
    
        let params = ["session_id":session.Id,
                      "referral": location,
                      "utm_source":"",
                      "utm_medium":"",
                      "utm_campaign":"",
                      "utm_content":"",
                      "utm_term":"",
                      "gclid":""] as NSMutableDictionary
    
        _eventCollectionService.SendEvent(table: "session_info", key: deviceId, params: params)
        
        _settings.setSessionStart(status: true)
        
    }
    
    ///- Parameter params: NSMutableDictionary
    public func PageView(params : NSMutableDictionary){
        
        let sessionId = _settings.getSessionId()
        let deviceId = _settings.getApplicationIdentifier()
        
        params["session_id"] = sessionId
        
        _eventCollectionService.SendEvent(table: "page_view_events", key: deviceId, params: params)
        
    }
    
    private func sendCartEvents(eventType : String, params : NSMutableDictionary){
        
        sendListEvents(table: "shopping_cart_events", withDetailTable: "shopping_cart_events_detail", eventType: eventType, params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func AddToCart(params : NSMutableDictionary) {
        sendCartEvents(eventType: "add_to_cart", params: params);
    }

    ///- Parameter params: NSMutableDictionary
    public func RemoveFromCart(params : NSMutableDictionary) {
        sendCartEvents(eventType: "remove_from_cart", params: params);
    }

    ///- Parameter params: NSMutableDictionary
    public func ViewCart(params : NSMutableDictionary) {
        sendCartEvents(eventType: "view_cart", params: params);
    }

    ///- Parameter params: NSMutableDictionary
    public func BeginCheckout(params : NSMutableDictionary) {
        sendCartEvents(eventType: "begin_checkout", params: params);
    }
    
    ///- Parameter params: NSMutableDictionary
    public func Order(params : NSMutableDictionary){
        
        let sessionId = _settings.getSessionId()
        let device_id = _settings.getApplicationIdentifier();
        let order_id = params["order_id"] as! String
        
        params["session_id"] = sessionId
        
        let temp = params.mutableCopy() as! NSMutableDictionary
        temp.removeObject(forKey: "cartItems")
        
        _eventCollectionService.SendEvent(table: "order_events", key: device_id, params: temp)
        
        let event_id = _utilities.generateUUID()
        let cartEventParams = ["session_id": sessionId,
                               "event_type":"order",
                               "event_id":event_id] as NSMutableDictionary
        
        _eventCollectionService.SendEvent(table: "shopping_cart_events", key: device_id, params: cartEventParams);
        
        let cartItems = params["cartItems"] as! [NSMutableDictionary]
        
        for cartItem in cartItems
        {
            _eventCollectionService.SendEvent(table: "order_events_details", key: order_id, params: cartItem)
        }
        
    }
    
    ///- Parameter params: NSMutableDictionary
    public func Search(params: NSMutableDictionary){
        
        let sessionId = _settings.getSessionId()
        let device_id = _settings.getApplicationIdentifier();
        
        params["session_id"] = sessionId
        
        _eventCollectionService.SendEvent(table: "search_events", key: device_id, params: params);
    }
    

    private func sendWishlistEvents(eventType : String, params : NSMutableDictionary){
        
        sendListEvents(table: "wishlist_events", withDetailTable: "wishlist_events_detail", eventType: eventType, params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func AddToWithList(params: NSMutableDictionary){
        sendWishlistEvents(eventType: "add", params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func RemoveFromWithList(params: NSMutableDictionary){
        sendWishlistEvents(eventType: "remove", params: params)
    }
    
    
    private func sendListEvents(table : String, withDetailTable: String, eventType:String,  params: NSMutableDictionary){
        
        let sessionId = _settings.getSessionId()
        let device_id = _settings.getApplicationIdentifier();
        let event_id = _utilities.generateUUID()
        
        params["session_id"] = sessionId
        params["event_type"] = eventType
        params["event_id"] = event_id
        
        let temp = params.mutableCopy() as! NSMutableDictionary
        temp.removeObject(forKey: "cartItems")
        
        _eventCollectionService.SendEvent(table: table, key: device_id, params: temp)
        
        let cartItems = params["cartItems"] as! [NSMutableDictionary]
        
        for cartItem in cartItems
        {
            _eventCollectionService.SendEvent(table: withDetailTable, key: event_id, params: cartItem)
        }
    }
    
}
