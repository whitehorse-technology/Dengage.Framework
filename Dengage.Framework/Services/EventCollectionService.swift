//
//  DengageEventCollectionService.swift
//  dengage.ios.sdk
//
//  Created by Developer on 21.10.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log

internal class EventCollectionService : BaseService
{
    
    let settings = Settings.shared
    
    public override init(){}
    
    internal func PostEventCollection(eventCollectionModel : EventCollectionModel)
    {
        let urladdress = EVENT_SERVICE_URL
        
        logger.Log(message: "EVENT_API_URL is %s", logtype: .info, argument: urladdress)
        
        var eventCollectionHttpRequest = EventCollectionHttpRequest()
        eventCollectionHttpRequest.IntegrationKey = settings.getDengageIntegrationKey()
        eventCollectionHttpRequest.key = eventCollectionModel.key
        eventCollectionHttpRequest.eventTable = eventCollectionModel.eventTable
        eventCollectionHttpRequest.eventDetails = eventCollectionModel.eventDetails
        
        
        let parameters = ["integrationKey": eventCollectionHttpRequest.IntegrationKey,
                          "key" : eventCollectionHttpRequest.key,
                          "eventTable" : eventCollectionHttpRequest.eventTable,
                          "eventDetails" : eventCollectionHttpRequest.eventDetails as Any
            ] as [String : Any]
        
        ApiCall(data: parameters, urlAddress: urladdress)
        
        logger.Log(message: "EVENT_COLLECTION_SENT", logtype: .info)
        
    }
    
}
