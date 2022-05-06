//
//  OpenEventService.swift
//  test.application
//
//  Created by Developer on 8.08.2019.
//  Copyright © 2019 Dengage All rights reserved.
//

import Foundation
import os.log

internal class OpenEventService : BaseService {

    internal func postOpenEvent(openEventHttpRequest: OpenEventHttpRequest) {
        let urladdress = settings.getSubscriptionApi() + "/api/mobile/open"

        logger.Log(message: "OPEN_API_URL is %s", logtype: .info, argument: urladdress)
        
        var parameters = ["integrationKey": openEventHttpRequest.integrationKey,
                          "messageId": openEventHttpRequest.messageId,
                          "messageDetails": openEventHttpRequest.messageDetails, "itemId": "", "buttonId": ""
        ] as [String : Any]
        
        if !openEventHttpRequest.buttonId.isEmpty{
            parameters["buttonId"] = openEventHttpRequest.buttonId
        }
        
        eventCall(with: parameters, for: urladdress)
        logger.Log(message: "OPEN_EVENT_SENT", logtype: .info)
    }
    
}
