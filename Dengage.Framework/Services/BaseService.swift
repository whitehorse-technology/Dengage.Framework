//
//  BaseService.swift
//  dengage.ios.sdk
//
//  Created by Developer on 27.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation

internal class BaseService {
    
    let logger: SDKLogger
    let session: URLSession
    let settings: Settings
    
    init() {
        
        logger = .shared
        session = .shared
        settings = .shared
    }
    
    init(logger: SDKLogger = .shared,
         session: URLSession = .shared,
         settings: Settings = .shared) {
        
        self.logger  = logger
        self.session = session
        self.settings = settings
    }

    internal func apiCall(data: Any, urlAddress: String) {

        let url = URL(string: urlAddress)!
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            // pass dictionary to nsdata object and set it as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
            logger.Log(message: "HTTP REQUEST BODY: %s",
                       logtype: .debug,
                       argument: String(data: request.httpBody!,
                                        encoding: String.Encoding.utf8)!)
        } catch let error {
            self.logger.Log(message: "%s", logtype: .error, argument: error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let userAgent = settings.getUserAgent()
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        logger.Log(message:"USER_AGENT is %s",  logtype: .debug, argument:  userAgent)
        
        let task = session.dataTask(with: request, completionHandler: handler(data:urlResponse:error:))
        
        task.resume()
    }
    
    func handler(data: Data?, urlResponse: URLResponse?, error: Error?){
        
        if error != nil {
            self.logger.Log(message: "API_CALL_ERROR %s", logtype: .error, argument: error!.localizedDescription)
        }
        
        if let response = urlResponse as? HTTPURLResponse {
            self.logger.Log(message: "RESPONSE_STATUS %s", logtype: .debug, argument: "\(response.statusCode)")
        }
        
        if let safeData = data {
            let dataString = String(data:safeData, encoding: .utf8)
            
            if dataString!.isEmpty == false {
                self.logger.Log(message: "API_RESPONSE %s", logtype: .debug, argument: dataString!)
            }
        }
        
    }
}
