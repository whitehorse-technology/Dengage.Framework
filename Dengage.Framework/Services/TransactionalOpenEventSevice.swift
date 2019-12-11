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
    
    public override init(){}
    
    internal func PostOpenEvent(transactionalOpenEventHttpRequest : TransactionalOpenEventHttpRequest)
    {
        let urladdress = TRANSACTIONAL_OPEN_SERVICE_URL
        
        logger.Log(message: "TRANSACTIONAL_OPEN_URL is %s", logtype: .info, argument: urladdress)
        
        let parameters = ["integrationKey": transactionalOpenEventHttpRequest.integrationId,
                          "transactionId" : transactionalOpenEventHttpRequest.transactionId,
                          "messageId" : transactionalOpenEventHttpRequest.messageId,
                          "messageDetails" : transactionalOpenEventHttpRequest.messageDetails
            ] as [String : Any]
        
        
        ApiCall(data: parameters, urlAddress: urladdress)
        
        logger.Log(message: "TRANSACTIONAL_OPEN_EVENT_SENT", logtype: .info)
    }
    
}
