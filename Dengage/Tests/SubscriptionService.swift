//
//  SubscriptionService.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class SubscriptionServiceTestCase: XCTestCase {
    
    var logMock: SDKLoggerMock = SDKLoggerMock()
    var urlSessionMock: URLSessionMock = URLSessionMock()
    var settingsMock: SettingsMock = SettingsMock()
    
    var sut: SubscriptionService = SubscriptionService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SubscriptionService.init(logger: logMock, session: urlSessionMock, settings: settingsMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSendSubscriptionEvent() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        sut.sendSubscriptionEvent()
    }

}
