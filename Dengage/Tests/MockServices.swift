//
//  MockServices.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
@testable import Dengage_Framework

class OpenEventServiceMock : OpenEventService {
    
    override func PostOpenEvent(openEventHttpRequest: OpenEventHttpRequest) {
        
    }
    
}

class TransactioanlOpenEventServiceMock : TransactioanlOpenEventService {
    
    
    override func PostOpenEvent(transactionalOpenEventHttpRequest: TransactionalOpenEventHttpRequest) {
        
    }
}

class SubscriptionServiceMock : SubscriptionService {
    
    override func SendSubscriptionEvent() {
        
    }
}

class EventCollectionServiceMock : EventCollectionService {
    
    override func PostEventCollection(eventCollectionModel: EventCollectionModel) {
        
    }
}
