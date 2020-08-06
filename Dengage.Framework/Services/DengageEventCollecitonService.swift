//
//  DengageEventCollecitonService.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 20.03.2020.
//

import Foundation

@available(swift, deprecated: 2.5.0)
internal class DengageEventCollecitonService {
    
    internal static let shared  = DengageEventCollecitonService()
    
    let EVENT_URL = DENGAGE_EVENT_SERVICE_URL
    
    let logger: SDKLogger
    let session: URLSession
    let settings: Settings
    
    var url: String = ""
    
    var dengageEventQueue: DengageEventQueue
    
    init() {
        
        logger = .shared
        session = .shared
        settings = .shared
        dengageEventQueue = DengageEventQueue()
    }
    
    init(logger: SDKLogger = .shared,
         session: URLSession = .shared,
         settings: Settings = .shared) {
        
        self.logger  = logger
        self.session = session
        self.settings = settings
        dengageEventQueue = DengageEventQueue()
    }
    
    internal func startSession(actionUrl: String?) {
        
        let sessionId = settings.getSessionId()
        url = DENGAGE_EVENT_SERVICE_URL //default value
        
        url.append(settings.getDengageIntegrationKey())
        
        logger.Log(message: "SESSION_ID %s", logtype: .debug, argument: sessionId)
        
        let params = ["evetName": "sessionStart",
                      "language": Locale.current.languageCode as Any,
                      "screenWidth": UIScreen.main.bounds.width,
                      "screenHeight":UIScreen.main.bounds.height,
                      "timeZone": TimeZone.current.offsetFromUTC(),
                      "sdkVersion": settings.getSdkVersion(),
                      "referrer": "",
                      "location": actionUrl ?? "",
                      "userAgent": settings.getUserAgent(),
                      "advertisingId": settings.getAdvertisinId() as Any,
                      "carrierId": settings.getCarrierId(),
                      "token": settings.getToken() ?? "",
                      "appVersion": settings.getAppversion()!,
                      "permission": settings.getPermission() as Any,
                      "os": UIDevice.current.systemName,
                      "model": UIDevice.modelName,
                      "manufacturer": "",
                      "brand": "",
                      "deviceUniqueId": UIDevice.current.identifierForVendor?.uuidString as Any,
                      "contactKey": settings.getContactKey() as Any,
                      "udid": settings.getApplicationIdentifier(),
                      "sessionId": sessionId
            
            ] as [String: Any]
        
        settings.setSessionStart(status: true)
        
        apiCall(data: params, urlAddress: url)
        logger.Log(message: "CLOUDsession_SENT", logtype: .debug)
    }
    
    internal func subscriptionEvent() {
        
        let sessionStarted = settings.getSessionStart()
        
        if sessionStarted {
            let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
            
            let sessionId = settings.getSessionId()
            let persistentId = settings.getApplicationIdentifier()
            logger.Log(message: "SESSION_ID %s", logtype: .debug, argument: sessionId)
            
            var subscriptionHttpRequest = SubscriptionHttpRequest()
            subscriptionHttpRequest.integrationKey = settings.getDengageIntegrationKey()
            subscriptionHttpRequest.contactKey = settings.getContactKey() ?? ""
            subscriptionHttpRequest.permission = settings.getPermission() ?? false
            subscriptionHttpRequest.appVersion = settings.getAppversion() ?? "1.0"
            
            let parameters = ["integrationKey": subscriptionHttpRequest.integrationKey,
                              "token": settings.getToken() ?? "",
                              "tokenType": "I",
                              "contactKey": subscriptionHttpRequest.contactKey,
                              "permission": subscriptionHttpRequest.permission,
                              "udid":       settings.getApplicationIdentifier(),
                              "carrierId":  settings.getCarrierId(),
                              "appVersion": subscriptionHttpRequest.appVersion,
                              "sdkVersion": settings.getSdkVersion(),
                              "advertisingId": settings.getAdvertisinId() as Any] as NSMutableDictionary
            
            
            parameters["eventName"] = "subscription"
            parameters["sessionId"] = sessionId
            parameters["udid"] = persistentId
            
            queue.async {
                self.apiCall(data: parameters, urlAddress: self.url)
            }
            
            logger.Log(message: "CLOUD_SUBSCRIPTION_EVENT_SENT", logtype: .debug)
            
        }
    }
    
    internal func TokenRefresh(token: String) {
        
        let sessionStarted = settings.getSessionStart()
        
        if sessionStarted {
            
            let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
            
            let sessionId = settings.getSessionId()
            let persistentId = settings.getApplicationIdentifier()
            let contactKey = settings.getContactKey()
            let testGroup = settings.getTestGroup()
            
            let params = [ "token": token ] as NSMutableDictionary
            
            params["eventName"] = "sdkTokenAction"
            params["sessionId"] = sessionId
            params["udid"] = persistentId
            params["contactKey"] = contactKey
            params["testGroup"] = testGroup
            
            queue.async {
                self.apiCall(data: params, urlAddress: self.url)
            }
            
            self.logger.Log(message: "TOKEN_REFRESH_EVENT_SENT", logtype: .debug)
        }
        
    }
    
    internal func customEvent(eventName: String, entityType: String?, pageType: String?, params: NSMutableDictionary) {
        
        let sessionStarted = settings.getSessionStart()
        
        if sessionStarted {
            
            let sessionId = settings.getSessionId()
            let persistentId = settings.getApplicationIdentifier()
            let contactKey = settings.getContactKey()
            let testGroup = settings.getTestGroup()
            
            if  entityType != nil && entityType!.isEmpty == false {
                params["entityType"] = entityType
                logger.Log(message: "ENTITY_TYPE is %s", logtype: .debug, argument: entityType!)
            }
            
            if pageType != nil && pageType!.isEmpty == false {
                params["pageType"] = pageType
                logger.Log(message: "PAGE_TYPE is %s", logtype: .debug, argument: pageType!)
            }
            
            params["eventName"] = eventName
            params["sessionId"] = sessionId
            params["udid"] = persistentId
            params["contactKey"] = contactKey
            params["testGroup"] = testGroup
            
            let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
            
            queue.async {
                self.apiCall(data: params, urlAddress: self.url)
            }
            
            logger.Log(message: "CLOUD_EVENT_SENT", logtype: .debug)
        }
        
    }
    
    internal func syncEventQueue() {
        
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        logger.Log(message: "Syncing EventCollection Queue...", logtype: .info)
        while dengageEventQueue.items.count > 0 {
            
            let eventcollection  = dengageEventQueue.dequeue()!
            
            queue.async {
                self.apiCall(data: eventcollection, urlAddress: self.url)
            }
            
            self.logger.Log(message: "CLOUD_EVENT_SENT", logtype: .debug)
        }
        logger.Log(message: "Sync EvenCollection is completed", logtype: .info)
    }
}



extension DengageEventCollecitonService {
    
    func apiCall(data: Any, urlAddress: String) {
        
        let url = URL(string: urlAddress)!
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: []) // pass dictionary to nsdata object and set it as request body
            
            
            let httpData = String(data: jsonData,encoding: .utf8)?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.data(using: .utf8)?.base64EncodedData()
            
            request.httpBody = httpData
            
            //            self.logger.Log(message: "HTTP REQUEST BODY: %s", logtype: .debug, argument: String(data: jsonData, encoding: String.Encoding.utf8)!)
        } catch let error {
            self.logger.Log(message: "%s", logtype: .error, argument: error.localizedDescription)
        }
        
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            
            guard let data = data else { return }
            
            guard data.count != 0 else { return }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    self.logger.Log(message: "API_RESPONSE %s", logtype: .debug, argument: "\(json)")
                }
            } catch let error {
                self.logger.Log(message: "API_CALL_ERROR %s", logtype: .error, argument: error.localizedDescription)
                
            }
        })
        
        task.resume()
    }
    
}
