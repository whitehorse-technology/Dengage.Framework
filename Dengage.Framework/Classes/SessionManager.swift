//
//  SessionManager.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 21.03.2020.
//

import Foundation


internal class SessionManager
{
    static let shared  = SessionManager()
    
    var sessionObj : Session? = nil
    
    let sessionInterval: Double = 1800
    
    internal func getSession()-> Session{
        
        
        if sessionObj == nil {
            
            sessionObj = Session()
            
            let interval  = Date().addingTimeInterval(sessionInterval)
            sessionObj?.Id = generateSessionId()
            sessionObj?.ExpireIn = interval
            
            return sessionObj!
        }
        else
        {
            if sessionObj!.ExpireIn > Date() {
                
                sessionObj!.ExpireIn = sessionObj!.ExpireIn.addingTimeInterval(sessionInterval)
                return sessionObj!
                
            }
            else {
                
                sessionObj?.Id = generateSessionId()
                sessionObj?.ExpireIn = Date().addingTimeInterval(sessionInterval)
                
                return sessionObj!
                
            }

        }
    }
    
    private func generateSessionId() -> String {
        
        return NSUUID().uuidString.lowercased()
    }
}
