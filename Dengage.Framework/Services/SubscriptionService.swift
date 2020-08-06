//
//  SubscriptionService.swift
//  test.application
//
//  Created by Developer on 8.08.2019.
//  Copyright © 2019 Dengage All rights reserved.
//

import Foundation
import os.log

internal class SubscriptionService : BaseService
{
    
    internal func SendSubscriptionEvent()
    {
        
        let  urladdress = SUBSCRIPTION_SERVICE_URL
        
        _logger.Log(message: "SUBSCRIPTION_URL is %s", logtype: .info, argument: urladdress)
        
        var subscriptionHttpRequest = SubscriptionHttpRequest()
        subscriptionHttpRequest.integrationKey = _settings.getDengageIntegrationKey()
        subscriptionHttpRequest.contactKey = _settings.getContactKey() ?? ""
        subscriptionHttpRequest.permission = _settings.getPermission() ?? false
        subscriptionHttpRequest.appVersion = _settings.getAppversion() ?? "1.0"
        
        
        let parameters = ["integrationKey": subscriptionHttpRequest.integrationKey,
                          "token": _settings.getToken() ?? "",
                          "contactKey": subscriptionHttpRequest.contactKey,
                          "permission": subscriptionHttpRequest.permission,
                          "udid":       _settings.getApplicationIdentifier(),
                          "carrierId":  _settings.getCarrierId(),
                          "appVersion": subscriptionHttpRequest.appVersion,
                          "sdkVersion": _settings.getSdkVersion(),
                          "tokenType": "I",
                          "advertisingId" : _settings.getAdvertisinId() as Any] as [String : Any]
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        
        queue.async {
            self.ApiCall(data: parameters, urlAddress: urladdress)
        }
        _logger.Log(message: "SUBSCRIPTION_EVENT_SENT", logtype: .info)
        
    }
}
