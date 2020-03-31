//
//  DengageApi.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {
    
    
    //    MARK:-
    //    MARK:- API calls
    @available(*, renamed: "SendSubscriptionEvent")
    public static func SyncSubscription() {
        
        
        if(_settings.getAdvertisinId()!.isEmpty){
            _logger.Log(message: "ADV_ID_IS_EMPTY", logtype: .info)
            return
        }
        if(_settings.getApplicationIdentifier().isEmpty){
            _logger.Log(message: "APP_IDF_ID_IS_EMPTY", logtype: .info)
            return
        }
        
        let cloudEnabled = _settings.getCloudEnabled()
        let sessionStarted = _settings.getSessionStart()
        
        if cloudEnabled == false {
            _subscriptionService.SendSubscriptionEvent()
        }
        else{
            
            if sessionStarted == false {
                StartSession(actionUrl: "")
                _dengageEventCollectionService.subscriptionEvent()
            }
        }
        
    }
    
    @available(*, renamed: "SendEventCollection")
    public static func SendDeviceEvent(toEventTable: String, andWithEventDetails: NSDictionary) -> Bool {
        
        if _settings.getDengageIntegrationKey().isEmpty{
            _logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            _logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.key = _settings.getApplicationIdentifier()
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.eventDetails = andWithEventDetails
        
        SyncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    public static func SendCustomEvent(toEventTable: String, withKey : String, andWithEventDetails: NSDictionary) -> Bool {
        
        if _settings.getDengageIntegrationKey().isEmpty{
            _logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        if toEventTable.isEmpty {
            _logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.key = withKey
        eventCollectionModel.eventDetails = andWithEventDetails
        
        SyncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }

    public static func SyncEventQueues(){
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .userInitiated)
        
        if(_eventQueue.items.count > QUEUE_LIMIT)
        {
            _logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
            while _eventQueue.items.count > 0 {
                
                let eventcollection  = _eventQueue.dequeue()!
                
                queue.async {
                    _eventCollectionService.PostEventCollection(eventCollectionModel: eventcollection)
                }
            }
            _logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
        }
    }
    

    
    // MARK:- Private Methods
    static func SyncEventQueues(eventCollectionModel: EventCollectionModel) {
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .userInitiated)
        
        if(_eventQueue.items.count < QUEUE_LIMIT)
        {
            _eventQueue.enqueue(element: eventCollectionModel)
        }
        else{
            
            _logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
            while _eventQueue.items.count > 0 {
                
                let eventcollection  = _eventQueue.dequeue()!
                
                queue.async {
                    _eventCollectionService.PostEventCollection(eventCollectionModel: eventcollection)
                }
            }
            _logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
            
            _eventQueue.enqueue(element: eventCollectionModel)
        }

    }
    
}
