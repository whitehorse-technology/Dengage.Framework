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
    let _logger : SDKLogger = .shared
    
    var queryParams : [String : Any] = [:]
    
    public static let shared  = DengageCustomEvent()
    
    ///Before sending an event Dengage.Framework opens  a Session by defualt.
    ///But according to implementation, developer can able to open a session manually.
    ///
    ///- Parameter location : *deeplinkUrl*
    public func SessionStart(referrer : String){
        
        
        if (_settings.getSessionStart() == true) {
            return
        }
        
        let session = _sessionManager.getSession()
        
        _settings.setSessionId(sessionId: session.Id)
        
        let deviceId = _settings.getApplicationIdentifier()
        
        QueryStringParser(urlString: referrer)
        
        let utmSource = getQueryStringValue(forKey: "utm_source")
        let utmMedium = getQueryStringValue(forKey: "utm_medium")
        let utmCampaign = getQueryStringValue(forKey: "utm_campaign")
        let utmContent = getQueryStringValue(forKey: "utm_content")
        let utmTerm = getQueryStringValue(forKey: "utm_term")
    
        let params = ["session_id":session.Id,
                      "referrer": referrer,
                      "utm_source": utmSource as Any,
                      "utm_medium": utmMedium as Any,
                      "utm_campaign":utmCampaign as Any,
                      "utm_content":utmContent as Any,
                      "utm_term":utmTerm as Any
            ] as NSMutableDictionary
    
        _eventCollectionService.SendEvent(table: "session_info", key: deviceId, params: params)
        
        _settings.setSessionStart(status: true)
        
        _logger.Log(message: "EVENT SESSION STARTED", logtype: .debug)
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
            cartItem["order_id"] = order_id
            _eventCollectionService.SendEvent(table: "order_events_details", key: device_id, params: cartItem)
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
            cartItem["event_id"] = event_id
            _eventCollectionService.SendEvent(table: withDetailTable, key: device_id, params: cartItem)
        }
    }
    
    private func QueryStringParser(urlString : String){
        let url = URL(string: urlString)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                
                queryParams[queryItem.name] = queryItem.value
                
            }
        }
    }
    
    private func getQueryStringValue(forKey : String) -> Any? {
        return queryParams[forKey] as? String
    }
    
}
