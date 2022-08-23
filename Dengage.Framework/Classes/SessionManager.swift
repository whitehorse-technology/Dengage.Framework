//
//  SessionManager.swift
//  Dengage.Framework
//
//  Created by Developer on 21.03.2020.
//

import Foundation

internal class SessionManager {
    static let shared  = SessionManager()
    var sessionObj: Session? = nil
    let sessionInterval: Double = 1800
    
    internal func getSession(restart: Bool) -> Session {
        
        if sessionObj == nil {
            
            sessionObj = Session()
            
            let interval  = Date().addingTimeInterval(sessionInterval)
            sessionObj?.sessionId = generateSessionId()
            sessionObj?.expireIn = interval
            
            return sessionObj!
        } else {
            if restart {
                
                sessionObj?.sessionId = generateSessionId()
                sessionObj?.expireIn = Date().addingTimeInterval(sessionInterval)
                
                return sessionObj!
            } else {
                if sessionObj!.expireIn > Date() {
                    
                    sessionObj!.expireIn = sessionObj!.expireIn.addingTimeInterval(sessionInterval)
                    return sessionObj!
                    
                } else {
                    
                    sessionObj?.sessionId = generateSessionId()
                    sessionObj?.expireIn = Date().addingTimeInterval(sessionInterval)
                    
                    return sessionObj!
                }
            }
        }
    }
    
    private func generateSessionId() -> String {
        return NSUUID().uuidString.lowercased()
    }
}
