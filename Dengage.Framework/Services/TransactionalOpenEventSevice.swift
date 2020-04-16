//
//  TransactionalOpenEventSevice.swift
//  dengage.ios.sdk
//
//  Created by Developer on 16.09.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log

internal class TransactioanlOpenEventService : BaseService
{
    

    internal func PostOpenEvent(transactionalOpenEventHttpRequest : TransactionalOpenEventHttpRequest)
    {
        let urladdress = TRANSACTIONAL_OPEN_SERVICE_URL
        
        _logger.Log(message: "TRANSACTIONAL_OPEN_URL is %s", logtype: .info, argument: urladdress)
        
        var parameters = ["integrationKey": transactionalOpenEventHttpRequest.integrationId,
                          "transactionId" : transactionalOpenEventHttpRequest.transactionId,
                          "messageId" : transactionalOpenEventHttpRequest.messageId,
                          "messageDetails" : transactionalOpenEventHttpRequest.messageDetails
            ] as [String : Any]
        
        if transactionalOpenEventHttpRequest.buttonId.isEmpty == false {
            parameters["buttonId"] = transactionalOpenEventHttpRequest.buttonId
        }
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        
        queue.async {
            self.ApiCall(data: parameters, urlAddress: urladdress)
        }
        
        _logger.Log(message: "TRANSACTIONAL_OPEN_EVENT_SENT", logtype: .info)
    }
    
}
