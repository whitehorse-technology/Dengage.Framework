//
//  Session.swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 21.03.2020.
//

import Foundation

class Session {
    
    var sessionId: String = ""
    var expireIn: Date = Date()
    
    internal init(sessionId: String, expireIn: Date) {
        self.sessionId = sessionId
        self.expireIn = expireIn
    }
}
