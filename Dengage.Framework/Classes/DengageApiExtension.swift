//
//  DengageApi.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {

     static var subscriptionService: SubscriptionService = SubscriptionService()
     static var dengageEventCollectionService: DengageEventCollecitonService = .shared
    
    //    MARK: -
    //    MARK: - API calls
    @available(*, renamed: "SendSubscriptionEvent")
    public static func SyncSubscription() {
        
        
        if settings.getAdvertisinId()!.isEmpty {
            logger.Log(message: "ADV_ID_IS_EMPTY", logtype: .info)
            return
        }
        if settings.getApplicationIdentifier().isEmpty  {
            logger.Log(message: "APP_IDF_ID_IS_EMPTY", logtype: .info)
            return
        }
        
        let cloudEnabled = settings.getCloudEnabled()
        let sessionStarted = settings.getSessionStart()
        
        if cloudEnabled == false {
            DengageCustomEvent.shared.SessionStart(referrer: "")
            subscriptionService.SendSubscriptionEvent()
        }
        else{
            
            if sessionStarted == false {
                StartSession(actionUrl: "")
                dengageEventCollectionService.subscriptionEvent()
            }
        }
        
    }
    
    @available(*, obsoleted:2.5.0, renamed: "SendEventCollection")
    public static func sendDeviceEvent(toEventTable: String, andWithEventDetails: NSDictionary) -> Bool {
        
        if settings.getDengageIntegrationKey().isEmpty {
            logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.key = settings.getApplicationIdentifier()
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.eventDetails = andWithEventDetails
        
        syncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    @available(*, obsoleted:2.5.0)
    public static func sendCustomEvent(toEventTable: String, withKey: String, andWithEventDetails: NSDictionary) -> Bool {
        
        if settings.getDengageIntegrationKey().isEmpty {
            logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.key = withKey
        eventCollectionModel.eventDetails = andWithEventDetails
        
        syncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    @available(*, obsoleted:2.5.0)
    public static func syncEventQueues() {

        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .userInitiated)
        
        if eventQueue.items.count > QUEUE_LIMIT {
            logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
            while eventQueue.items.count > 0 {
                
                let eventcollection  = eventQueue.dequeue()!
                
                queue.async {
                    eventCollectionService.PostEventCollection(eventCollectionModel: eventcollection)
                }
            }
            logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
        }
    }
    
    
    
    // MARK:- Private Methods
    static func syncEventQueues(eventCollectionModel: EventCollectionModel) {
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .userInitiated)
        
        if(eventQueue.items.count < QUEUE_LIMIT)
        {
            eventQueue.enqueue(element: eventCollectionModel)
        }
        else{
            
            logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
            while eventQueue.items.count > 0 {
                
                let eventcollection  = eventQueue.dequeue()!
                
                queue.async {
                    eventCollectionService.PostEventCollection(eventCollectionModel: eventcollection)
                }
            }
            logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
            
            eventQueue.enqueue(element: eventCollectionModel)
        }
        
    }
    
}
