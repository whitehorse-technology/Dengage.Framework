//
//  OpenEventService.swift
//  test.application
//
//  Created by Ekin Bulut on 8.08.2019.
//  Copyright © 2019 Whitehorse.Technology All rights reserved.
//

import Foundation
import os.log

internal class OpenEventService : BaseService
{


    internal func PostOpenEvent(openEventHttpRequest : OpenEventHttpRequest)
    {
        let urladdress = OPEN_EVENT_SERVICE_URL
        
        
        _logger.Log(message: "OPEN_API_URL is %s", logtype: .info, argument: urladdress)
        
        let parameters = ["integrationKey": openEventHttpRequest.integrationKey,
                          "messageId" : openEventHttpRequest.messageId,
                          "messageDetails" : openEventHttpRequest.messageDetails
            ] as [String : Any]
        
        ApiCall(data: parameters, urlAddress: urladdress)
        
        _logger.Log(message: "OPEN_EVENT_SENT", logtype: .info)
        
    }
    
}




