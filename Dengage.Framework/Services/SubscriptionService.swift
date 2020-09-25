//
//  SubscriptionService.swift
//  test.application
//
//  Created by Developer on 8.08.2019.
//  Copyright © 2019 Dengage All rights reserved.
//

import Foundation
import os.log

internal class SubscriptionService: BaseService {

    internal func sendSubscriptionEvent() {

        let  urladdress = SUBSCRIPTION_SERVICE_URL + "/api/device/subscription"
        
        logger.Log(message: "SUBSCRIPTION_URL is %s", logtype: .info, argument: urladdress)
        
        var subscriptionHttpRequest = SubscriptionHttpRequest()
        subscriptionHttpRequest.integrationKey = settings.getDengageIntegrationKey()
        subscriptionHttpRequest.contactKey = settings.getContactKey() ?? ""
        subscriptionHttpRequest.permission = settings.getPermission() ?? false
        subscriptionHttpRequest.appVersion = settings.getAppversion() ?? "1.0"
        
        let parameters = ["integrationKey": subscriptionHttpRequest.integrationKey,
                          "token": settings.getToken() ?? "",
                          "contactKey": subscriptionHttpRequest.contactKey,
                          "permission": subscriptionHttpRequest.permission,
                          "udid": settings.getApplicationIdentifier(),
                          "carrierId": settings.getCarrierId(),
                          "appVersion": subscriptionHttpRequest.appVersion,
                          "sdkVersion": settings.getSdkVersion(),
                          "tokenType": "I",
                          "advertisingId" : settings.getAdvertisinId() as Any] as [String: Any]
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        
        queue.async {
            self.apiCall(data: parameters, urlAddress: urladdress)
        }
        logger.Log(message: "SUBSCRIPTION_EVENT_SENT", logtype: .info)
        
    }
}
