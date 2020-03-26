//
//  DengageEventCollecitonService.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 20.03.2020.
//

import Foundation


internal class DengageEventCollecitonService {
    
    
    internal static let shared  = DengageEventCollecitonService()
    
    var EVENT_URL = DENGAGE_EVENT_SERVICE_URL
    
    let _logger : SDKLogger
    let _session : URLSession
    let _settings : Settings
    
    var url : String = ""
    
    
    init(){
        
        _logger = .shared
        _session = .shared
        _settings = .shared
    }
    
    init(logger: SDKLogger = .shared, session : URLSession = .shared, settings : Settings = .shared){
        
        _logger  = logger
        _session = session
        _settings = settings
        
    }
    
    internal func startSession(actionUrl : String?){
        
        let sessionId = _settings.getSessionId()
        url = DENGAGE_EVENT_SERVICE_URL //default value
        
        if _settings.getSubscriptionUrl().isEmpty == false
        {
            url = _settings.getSubscriptionUrl()
        }
        
        url.append(_settings.getDengageIntegrationKey())
        
        _logger.Log(message: "SESSION_ID %s", logtype: .debug, argument: sessionId)
        
        let params = ["evetName": "sessionStart",
                      "language": Locale.current.languageCode as Any,
                      "screenWidth": UIScreen.main.bounds.width,
                      "screenHeight":UIScreen.main.bounds.height,
                      "timeZone": TimeZone.current.offsetFromUTC(),
                      "sdkVersion":_settings.getSdkVersion(),
                      "referrer" : "",
                      "location" : actionUrl ?? "",
                      "userAgent" : _settings.getUserAgent(),
                      "advertisingId" : _settings.getAdvertisinId() as Any,
                      "carrierId" : _settings.getCarrierId(),
                      "token" : _settings.getToken() ?? "",
                      "appVersion" : _settings.getAppversion()!,
                      "permission" : _settings.getPermission() as Any,
                      "os" : UIDevice.current.systemName,
                      "model" : UIDevice.modelName,
                      "manufacturer" : "",
                      "brand" : "",
                      "deviceUniqueId" : UIDevice.current.identifierForVendor?.uuidString as Any,
                      "memberId" : _settings.getContactKey() as Any,
                      "persistentId" : _settings.getApplicationIdentifier(),
                      "sessionId" : sessionId
            
            ] as [String : Any]
        
        _settings.setSessionStart(status: true)
        
        ApiCall(data: params, urlAddress: url)
          
    }
    
    internal func subscriptionEvent(){
        
        if _settings.getSessionStart() {
            
            let sessionId = _settings.getSessionId()
            let persistentId = _settings.getApplicationIdentifier()
            _logger.Log(message: "SESSION_ID %s", logtype: .debug, argument: sessionId)
            
            var subscriptionHttpRequest = SubscriptionHttpRequest()
            subscriptionHttpRequest.integrationKey = _settings.getDengageIntegrationKey()
            subscriptionHttpRequest.contactKey = _settings.getContactKey() ?? ""
            subscriptionHttpRequest.permission = _settings.getPermission() ?? false
            subscriptionHttpRequest.appVersion = _settings.getAppversion() ?? "1.0"
            
            
            let parameters = ["integrationKey": subscriptionHttpRequest.integrationKey,
                              "token": _settings.getToken() ?? "",
                              "tokenType" : "I",
                              "contactKey": subscriptionHttpRequest.contactKey,
                              "permission": subscriptionHttpRequest.permission,
                              "udid":       _settings.getApplicationIdentifier(),
                              "carrierId":  _settings.getCarrierId(),
                              "appVersion": subscriptionHttpRequest.appVersion,
                              "sdkVersion": _settings.getSdkVersion(),
                              "advertisingId" : _settings.getAdvertisinId() as Any] as NSMutableDictionary
            
            
            parameters["eventName"] = "subscription"
            parameters["sessionId"] = sessionId
            parameters["persistentId"] = persistentId
            
            
            ApiCall(data: parameters, urlAddress: url)
            
        }
    }
    
    internal func customEvent(eventName : String , entityType : String?, pageType : String?, params : NSMutableDictionary){
        
        if _settings.getSessionStart() {
            
            let sessionId = _settings.getSessionId()
            let persistentId = _settings.getApplicationIdentifier()
            let memberId = _settings.getContactKey()
            let testGroup = _settings.getTestGroup()
            
            
            if  entityType != nil && entityType!.isEmpty {
                params["entityType"] = entityType
            }
            
            if pageType != nil && pageType!.isEmpty {
                params["pageType"] = pageType
            }
            
            params["eventName"] = eventName
            params["sessionId"] = sessionId
            params["persistentId"] = persistentId
            params["memberId"] = memberId
            params["testGroup"] = testGroup
            
            ApiCall(data: params, urlAddress: url)
        }
        
    }
    
    
}



extension DengageEventCollecitonService {
    
    
    func ApiCall(data: Any, urlAddress: String){
        
        
        let url = URL(string: urlAddress)!
        
        _logger.Log(message: "EVENT_URL is %s", logtype: .info, argument: urlAddress)
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: []) // pass dictionary to nsdata object and set it as request body
            
            
            let httpData = String(data: jsonData,encoding: .utf8)?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.data(using: .utf8)?.base64EncodedData()
            
            request.httpBody = httpData
            
//            self._logger.Log(message: "HTTP REQUEST BODY : %s", logtype: .debug, argument: String(data: request.httpBody!, encoding: String.Encoding.utf8)!)
        } catch let error {
            self._logger.Log(message: "%s", logtype: .error, argument: error.localizedDescription)
        }
        
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        //create dataTask using the session object to send data to the server
        let task = _session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard data.count != 0 else {
                self._logger.Log(message: "CLOUD_EVENT_SENT", logtype: .debug)
                return
            }
            
            do {
                
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    self._logger.Log(message: "API_RESPONSE %s", logtype: .debug, argument: "\(json)")
                    // handle json...
                }
            } catch let error {
                self._logger.Log(message: "API_CALL_ERROR %s", logtype: .error, argument: error.localizedDescription)
                
            }
        })
        
        task.resume()
    }
    
}