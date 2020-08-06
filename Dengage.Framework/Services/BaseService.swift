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

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, _, error in
            
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
                if let json = try JSONSerialization.jsonObject(with: data,
                                                               options: .mutableContainers) as? [String: Any] {
                    
                    self.logger.Log(message: "API_RESPONSE %s", logtype: .debug, argument: "\(json)")
                    // handle json...
                }
            } catch let error {
                self.logger.Log(message: "API_CALL_ERROR %s", logtype: .error, argument: error.localizedDescription)
                
            }
        })
        
        task.resume()
    }
}
