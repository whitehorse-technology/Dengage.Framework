//
//  DengageApi.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {
    
    static var subscriptionService: SubscriptionService = SubscriptionService()
    
    //MARK: - API calls
    public static func syncSubscription(){
        
        guard !settings.getApplicationIdentifier().isEmpty else {
            logger.Log(message: "APP_IDF_ID_IS_EMPTY", logtype: .info)
            return
        }
        
        DengageEvent.shared.SessionStart(referrer: "", restart: false)
        subscriptionService.sendSubscriptionEvent()
    }
    
    
    @available(*, renamed: "SendEventCollection")
    public static func SendDeviceEvent(toEventTable: String, andWithEventDetails: NSMutableDictionary) -> Bool {
        
        guard !settings.getDengageIntegrationKey().isEmpty else {
            logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        guard !toEventTable.isEmpty else {
            logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        andWithEventDetails["session_id"] = settings.getSessionId()
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.key = settings.getApplicationIdentifier() //device_id
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.eventDetails = andWithEventDetails
        
        syncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    public static func SendCustomEvent(toEventTable: String, withKey : String, andWithEventDetails: NSMutableDictionary) -> Bool {
        
        guard !settings.getDengageIntegrationKey().isEmpty else {
            logger.Log(message: "INTEGRATION_KEY_IS_EMPTY", logtype: .info)
            return false
        }
        
        guard !toEventTable.isEmpty else {
            logger.Log(message: "EVENT_TABLE_IS_EMPTY", logtype: .info)
            return false
        }
        
        var eventCollectionModel = EventCollectionModel()
        
        eventCollectionModel.key = withKey
        eventCollectionModel.eventTable = toEventTable
        eventCollectionModel.eventDetails = andWithEventDetails
        
        syncEventQueues(eventCollectionModel: eventCollectionModel)
        return true
    }
    
    // MARK:- Private Methods
    static func syncEventQueues(eventCollectionModel: EventCollectionModel) {
        
        logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
        eventCollectionService.PostEventCollection(eventCollectionModel: eventCollectionModel)
        logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
    }
}
