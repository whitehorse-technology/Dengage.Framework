//
//  DengageCustomEvent.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 30.05.2020.
//

import Foundation


@available(swift, introduced: 2.5.0)
public class DengageEvent {

    let settings: Settings = .shared
    let logger: SDKLogger = .shared
    let eventCollectionService: EventCollectionService = EventCollectionService()
    var flushTimer: Timer?
    var queryParams: [String: Any] = [:]

    public static let shared = DengageEvent()

    
    ///Before sending an event Dengage.Framework opens  a Session by defualt.
    ///But according to implementation, developer can able to open a session manually.
    ///

    ///- Parameter location: *deeplinkUrl*
    internal func SessionStart(referrer: String, restart: Bool) {
        
        let session = SessionManager.shared.getSession(restart: restart)
        let referrerAdress = settings.getReferrer() ?? referrer
        
        settings.setSessionId(sessionId: session.sessionId)
        
        let deviceId = settings.getApplicationIdentifier()
        
        var params: NSMutableDictionary = [:]
        
        if  !referrerAdress.isEmpty {
            
            queryStringParser(urlString: referrer)

            let utmSource = getQueryStringValue(forKey: "utm_source")
            let utmMedium = getQueryStringValue(forKey: "utm_medium")
            let utmCampaign = getQueryStringValue(forKey: "utm_campaign")
            let utmContent = getQueryStringValue(forKey: "utm_content")
            let utmTerm = getQueryStringValue(forKey: "utm_term")
            let channel = getQueryStringValue(forKey: "dn_channel")
            let sendId = getQueryStringValue(forKey: "dn_send_id")
            
            settings.setChannel(source: channel ?? "")
            settings.setSendId(sendId: sendId ?? "")
            
            params = ["session_id": session.sessionId,
                      "referrer": referrerAdress,
                      "utm_source": utmSource as Any,
                      "utm_medium": utmMedium as Any,
                      "utm_campaign": utmCampaign as Any,
                      "utm_content": utmContent as Any,
                      "utm_term": utmTerm as Any
                ] as NSMutableDictionary
        } else {
            params = ["session_id":session.sessionId] as NSMutableDictionary
        }
        
        
        let sendId = settings.getSendId()
        if sendId != nil {
            params["channel"] = settings.getChannel()?.lowercased() ?? "push"
            params["send_id"] = settings.getSendId()
        }
        
        eventCollectionService.SendEvent(table: "session_info", key: deviceId, params: params)
        settings.setSessionStart(status: true)
        logger.Log(message: "EVENT SESSION STARTED", logtype: .debug)
        
        if flushTimer == nil {
            flushTimer = Timer.scheduledTimer(timeInterval: QUEUE_FLUSH_TIME, target: self, selector: #selector(flushEvents), userInfo: nil, repeats: true)
        }
    }
    
    ///- Parameter params: NSMutableDictionary
    public func pageView(params: NSMutableDictionary) {
        
        let sessionId = settings.getSessionId()
        let deviceId = settings.getApplicationIdentifier()
        
        params["session_id"] = sessionId
        
        eventCollectionService.SendEvent(table: "page_view_events", key: deviceId, params: params)
        
    }
    
    private func sendCartEvents(eventType: String, params: NSMutableDictionary) {
        
        sendListEvents(table: "shopping_cart_events",
                       withDetailTable: "shopping_cart_events_detail",
                       eventType: eventType,
                       params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func addToCart(params: NSMutableDictionary) {
        sendCartEvents(eventType: "add_to_cart",
                       params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func removeFromCart(params: NSMutableDictionary) {
        sendCartEvents(eventType: "remove_from_cart",
                       params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func viewCart(params: NSMutableDictionary) {
        sendCartEvents(eventType: "view_cart",
                       params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func beginCheckout(params: NSMutableDictionary) {
        sendCartEvents(eventType: "begin_checkout",
                       params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func order(params: NSMutableDictionary) {
        
        let sessionId = settings.getSessionId()
        let deviceId = settings.getApplicationIdentifier()
        
        params["session_id"] = sessionId
        params["event_type"] = "order"
        
        let temp = params.mutableCopy() as! NSMutableDictionary
        temp.removeObject(forKey: "cartItems")
        
        eventCollectionService.SendEvent(table: "order_events", key: deviceId, params: temp)
        
        let event_id = Utilities.shared.generateUUID()
        let cartEventParams = ["session_id": sessionId,
                               "event_type": "order",
                               "event_id": event_id] as NSMutableDictionary
        
        eventCollectionService.SendEvent(table: "shopping_cart_events", key: deviceId, params: cartEventParams)
        
        let cartItems = params["cartItems"] as! [NSMutableDictionary]
        
        for cartItem in cartItems {
            cartItem["order_id"] = params["order_id"]
            eventCollectionService.SendEvent(table: "order_events_details", key: deviceId, params: cartItem)
        }
        
    }
    
    ///- Parameter params: NSMutableDictionary
    public func cancelOrder(params: NSMutableDictionary) {
        
        let sessionId = settings.getSessionId()
        let deviceId = settings.getApplicationIdentifier()
        
        params["session_id"] = sessionId
        params["event_type"] = "cancel"
        params["total_amount"] = -(params["total_amount"] as! Int)
        
        let temp = params.mutableCopy() as! NSMutableDictionary
        temp.removeObject(forKey: "cartItems")
        
        eventCollectionService.SendEvent(table: "order_events", key: deviceId, params: temp)
        
        let cartItems = params["cartItems"] as! [NSMutableDictionary]
        
        for cartItem in cartItems {
            cartItem["order_id"] = params["order_id"]
            eventCollectionService.SendEvent(table: "order_events_details", key: deviceId, params: cartItem)
        }
        
    }
    
    ///- Parameter params: NSMutableDictionary
    public func search(params: NSMutableDictionary) {
        
        let sessionId = settings.getSessionId()
        let deviceId = settings.getApplicationIdentifier()
        
        params["session_id"] = sessionId
        
        eventCollectionService.SendEvent(table: "search_events", key: deviceId, params: params)
    }

    private func sendWishlistEvents(eventType: String, params: NSMutableDictionary) {

        
        sendListEvents(table: "wishlist_events", withDetailTable: "wishlist_events_detail", eventType: eventType, params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func addToWithList(params: NSMutableDictionary) {
        sendWishlistEvents(eventType: "add", params: params)
    }
    
    ///- Parameter params: NSMutableDictionary
    public func removeFromWithList(params: NSMutableDictionary) {
        sendWishlistEvents(eventType: "remove", params: params)
    }

    private func sendListEvents(table: String, withDetailTable: String, eventType:String, params: NSMutableDictionary) {
        
        let sessionId = settings.getSessionId()
        let deviceId = settings.getApplicationIdentifier()
        let eventId = Utilities.shared.generateUUID()
        
        params["session_id"] = sessionId
        params["event_type"] = eventType
        params["event_id"] = eventId
      
        let temp = params.mutableCopy() as! NSMutableDictionary
        temp.removeObject(forKey: "cartItems")
        
        eventCollectionService.SendEvent(table: table, key: deviceId, params: temp)
        
        let cartItems = params["cartItems"] as! [NSMutableDictionary]
        
        for cartItem in cartItems {
            cartItem["event_id"] = eventId
            eventCollectionService.SendEvent(table: withDetailTable, key: deviceId, params: cartItem)
        }
    }
 
    private func queryStringParser(urlString: String) {

        let url = URL(string: urlString)!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                queryParams[queryItem.name] = queryItem.value
            }
        }
    }

    private func getQueryStringValue(forKey: String) -> String? {

        return queryParams[forKey] as? String
    }
    
    @objc public func flushEvents() {
        guard settings.getSessionStart() else {
            logger.Log(message: "FLUSH_CALLED_BEFORE_SESSION_START", logtype: .info)
            return
        }
        eventCollectionService.flush()
    }
}
