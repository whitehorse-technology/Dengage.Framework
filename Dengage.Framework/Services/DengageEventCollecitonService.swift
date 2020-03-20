//
//  DengageEventCollecitonService.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 20.03.2020.
//

import Foundation


internal class DengageEventCollecitonService {
    
    let EVENT_URL = DENGAGE_EVENT_SERVICE_URL
    
    let _logger : SDKLogger
    let _session : URLSession
    let _settings : Settings
    
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
        
        /*
         {
         "eventName": "sessionStart",
         "language": "en-US",
         "screenWidth": 3200,
         "screenHeight": 1697,
         "timeZone": 3,
         "sdkVersion": "1.0.0",
         "os": "Android " + Build.VERSION.RELEASE
         "md": Build.MODEL,
         "mn": Build.MANUFACTURER,
         "br" : Build.BRAND
         "deviceUniqueId": getDeviceUniqueId(), --> Android icin metodu ekledim. IOS icin --> UIDevice.current.identifierForVendor?.uuidString
         "referrer": "",
         "location": "sessionBaslarken olusan deeplink degeri",
         "sessionId": "f55c920b-58d0-4581-b203-13a1036ee43a", --> Session basladiginda generate edilmeli.
         "persistentId": "1fa0bb6a-5e4a-4919-9cd7-458cb0795489" --> uygulama ilk yuklendiginde generate edilmelidir ve degismemeli,
         "pushToken" : "Push notification token"
         }
         */
            
        let params = ["evetName": "sessionStart",
                      "language": Locale.current.languageCode as Any,
                      "screenWidth": UIScreen.main.bounds.width,
                      "screenHeight":UIScreen.main.bounds.height,
                      "timeZone": TimeZone.current.offsetFromUTC(),
                      "sdkVersion":_settings.getSdkVersion(),
                      "os":UIDevice.current.systemVersion,
                      "md":UIDevice.modelName,
                      "mn":"",
                      "br":"",
                      "deviceUniqueId": UIDevice.current.identifierForVendor?.uuidString as Any,
                      "referrer" : "",
                      "location" : actionUrl ?? "",
                      "sessionId" : _settings.getSessionId(),
                      "persistentId" : _settings.getApplicationIdentifier(),
                      "pushToken" : _settings.getToken() ?? ""
            
            ] as [String : Any]
        
        
        
        ApiCall(data: params, urlAddress: EVENT_URL)
        
        
    }
    
    internal func pageView(params : inout [String : Any]){
        
       
        let sessionId = _settings.getSessionId()
        let persistentId = _settings.getApplicationIdentifier()
        
        params.updateValue("pageView", forKey: "eventName")
        params.updateValue(sessionId, forKey: "sessionId")
        params.updateValue(persistentId, forKey: "persistentId")
        
        ApiCall(data: params, urlAddress: EVENT_URL)
        
    }
    
    internal func customEvent(eventName : String ,params : inout [String : Any]){
        
        let sessionId = _settings.getSessionId()
        let persistentId = _settings.getApplicationIdentifier()
        
         params.updateValue(eventName, forKey: "eventName")
         params.updateValue(sessionId, forKey: "sessionId")
         params.updateValue(persistentId, forKey: "persistentId")
               
        
        ApiCall(data: params, urlAddress: EVENT_URL)
    }
    
    
}



extension DengageEventCollecitonService {
    
    
    func ApiCall(data: Any, urlAddress: String){
        
        
        let url = URL(string: urlAddress)!
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted).base64EncodedData() // pass dictionary to nsdata object and set it as request body
            
            self._logger.Log(message: "HTTP REQUEST BODY : %s", logtype: .debug, argument: String(data: request.httpBody!, encoding: String.Encoding.utf8)!)
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
