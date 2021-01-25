//
//  DengageEventCollectionService.swift
//  dengage.ios.sdk
//
//  Created by Developer on 21.10.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log

internal class EventCollectionService: BaseService {
    
    private var events = [[String : Any]]()
    private var requestInProgress = false
    
    internal func PostEventCollection(eventCollectionModel: EventCollectionModel) {
        
        var eventCollectionHttpRequest = EventCollectionHttpRequest()
        eventCollectionHttpRequest.integrationKey = settings.getDengageIntegrationKey()
        eventCollectionHttpRequest.key = eventCollectionModel.key
        eventCollectionHttpRequest.eventTable = eventCollectionModel.eventTable
        eventCollectionHttpRequest.eventDetails = eventCollectionModel.eventDetails

        let parameters = ["integrationKey": eventCollectionHttpRequest.integrationKey,
                          "key": eventCollectionHttpRequest.key,
                          "eventTable": eventCollectionHttpRequest.eventTable,
                          "eventDetails": eventCollectionHttpRequest.eventDetails as Any
            ] as [String: Any]
        
        addEventToQueue(event: parameters)
    
    }
    
    internal func SendEvent(table: String, key: String, params: NSDictionary) {
        
        var eventCollectionModel = EventCollectionModel()
        eventCollectionModel.key = key
        eventCollectionModel.eventTable = table
        eventCollectionModel.eventDetails = params
        PostEventCollection(eventCollectionModel: eventCollectionModel)
        
    }
    
    internal func flush() {
        let queueLimit = QUEUE_LIMIT
        let batches = stride(from: 0, to: events.count, by: queueLimit).map {
            Array(events[$0..<min($0 + queueLimit, events.count)])
        }
        events.removeAll()
        for batch in batches {
            uploadEventsBatch(batch: batch)
        }
    }
    
    private func addEventToQueue(event: [String: Any]) {
        events.append(event)
        sendEvents()
    }
    
    private func sendEvents() {
        let maxBatchCount = settings.getQueueLimit()
        if events.count >= maxBatchCount && events.count > 0 {
            let batch = Array(events.prefix(maxBatchCount))
            events.removeFirst(batch.count)
            uploadEventsBatch(batch: batch)
        }
    }
    
    private func uploadEventsBatch(batch: [[String: Any]]) {
        let urladdress = settings.getEventApiUrl() + "/api/event"
        logger.Log(message: "EVENT_API_URL is %s", logtype: .info, argument: urladdress)
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        queue.sync {
            self.apiCall(data: batch, urlAddress: urladdress) { [weak self] (success) in
                if success {
                    self?.logger.Log(message: "EVENT_COLLECTION_SENT", logtype: .info)
                } else {
                    self?.events.append(contentsOf: batch)
                }
            }
        }
    }
}
