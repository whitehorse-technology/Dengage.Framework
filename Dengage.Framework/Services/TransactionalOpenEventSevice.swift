//
//  TransactionalOpenEventSevice.swift
//  dengage.ios.sdk
//
//  Created by Developer on 16.09.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log

internal class TransactioanlOpenEventService: BaseService {

    internal func postOpenEvent(transactionalOpenEventHttpRequest: TransactionalOpenEventHttpRequest) {
    
        let urladdress = settings.getSubscriptionApi() + "/api/transactional/mobile/open"
        
        logger.Log(message: "TRANSACTIONAL_OPEN_URL is %s", logtype: .info, argument: urladdress)
        
        var parameters = ["integrationKey": transactionalOpenEventHttpRequest.integrationId,
                          "transactionId": transactionalOpenEventHttpRequest.transactionId,
                          "messageId": transactionalOpenEventHttpRequest.messageId,
                          "messageDetails": transactionalOpenEventHttpRequest.messageDetails
        ] as [String: Any]
        
        if !transactionalOpenEventHttpRequest.buttonId.isEmpty {
            parameters["buttonId"] = transactionalOpenEventHttpRequest.buttonId
        }
        
        eventCall(with: parameters, for: urladdress)
        
        logger.Log(message: "TRANSACTIONAL_OPEN_EVENT_SENT", logtype: .info)
    }
    
}
