//
//  SubscriptionService.swift
//  test.application
//
//  Created by Ekin Bulut on 8.08.2019.
//  Copyright © 2019 Whitehorse.Technology All rights reserved.
//

import Foundation
import os.log

internal class SubscriptionService : BaseService
{
    public override init(){}
    
    internal func SendSubscriptionEvent()
    {
        
        let  urladdress = SUBSCRIPTION_SERVICE_URL
        let settings = Settings.shared
        
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
                          "udid":       settings.getApplicationIdentifier(),
                          "carrierId":  settings.getCarrierId(),
                          "appVersion": subscriptionHttpRequest.appVersion,
                          "sdkVersion": settings.getSdkVersion(),
                          "advertisingId" : settings.getAdvertisinId() as Any] as [String : Any]
        
        ApiCall(data: parameters, urlAddress: urladdress)
        
        logger.Log(message: "SUBSCRIPTION_EVENT_SENT", logtype: .info)
        
    }
}
