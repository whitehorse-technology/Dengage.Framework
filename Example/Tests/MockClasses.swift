//
//  MockClasses.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 13.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import AdSupport
import CoreTelephony
@testable import Dengage_Framework


class ASIdentifierManagerMock : ASIdentifierManager{
    
    
}


class DengageLocalStorageMock : DengageLocalStorage{
    
    var value : String = ""
    
    
    override func setValueWithKey(value: String, key: String) {
        self.value = value
    }
    
    override func getValueWithKey(key: String) -> String? {
        return value
    }
}

class SDKLoggerMock : SDKLogger{
    
    
    
}

class CTTelephonyNetworkInfoMock : CTTelephonyNetworkInfo{
    
    
}

class CTCarrierMock : CTCarrier{
    
}

class URLSessionMock : URLSession {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
    
}

class SettingsMock : Settings{
    
    override func getUserAgent() -> String {
        return "iPhone DEV/1.4"
    }
    
    override func getDengageIntegrationKey() -> String {
        return "somekey"
    }
    
    override func getContactKey() -> String? {
        return nil
    }
    
    override func getPermission() -> Bool? {
        return nil
    }
    
    override func getAppversion() -> String? {
        return nil
    }
    
    override func getApplicationIdentifier() -> String {
        return "0000-0000-0000-0000"
    }
    
    override func getCarrierId() -> String {
        return "1"
    }
    
    override func getSdkVersion() -> String {
        return "1.0"
    }
    
    override func getAdvertisinId() -> String? {
        return "0000-0000-0000-0000"
    }
    
    override func getToken() -> String? {
        return nil
    }
}


class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
