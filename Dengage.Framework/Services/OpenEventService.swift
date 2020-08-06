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
        let urladdress = OPEN_EVENT_SERVICE_URL

        logger.Log(message: "OPEN_API_URL is %s", logtype: .info, argument: urladdress)
        
        var parameters = ["integrationKey": openEventHttpRequest.integrationKey,
                          "messageId": openEventHttpRequest.messageId,
                          "messageDetails": openEventHttpRequest.messageDetails
            ] as [String: Any]
        
        if openEventHttpRequest.buttonId.isEmpty == false {
            parameters["buttonId"] = openEventHttpRequest.buttonId
        }
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        
        queue.async {
            self.apiCall(data: parameters, urlAddress: urladdress)
        }
        logger.Log(message: "OPEN_EVENT_SENT", logtype: .info)
    }
    
}
