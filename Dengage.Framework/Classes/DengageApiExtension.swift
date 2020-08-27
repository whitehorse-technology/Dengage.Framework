//
//  DengageApi.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 27.03.2020.
//

import Foundation


extension Dengage {

     static var subscriptionService: SubscriptionService = SubscriptionService()
         
    //MARK: -
    //MARK: - API calls
    @available(*, renamed: "SendSubscriptionEvent")
    public static func SyncSubscription() {
        
        
        if settings.getAdvertisinId()!.isEmpty {
            logger.Log(message: "ADV_ID_IS_EMPTY", logtype: .info)
            return
        }
        if settings.getApplicationIdentifier().isEmpty  {
            logger.Log(message: "APP_IDF_ID_IS_EMPTY", logtype: .info)
            return
        }
        
        DengageEvent.shared.SessionStart(referrer: "", restart: false)
        subscriptionService.sendSubscriptionEvent()
        
    }
}
