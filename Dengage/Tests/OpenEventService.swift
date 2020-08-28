//
//  OpenEventService.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class OpenEventServiceTestCase: XCTestCase {

    var logMock: SDKLoggerMock = SDKLoggerMock()
    var urlSessionMock: URLSessionMock = URLSessionMock()
    var settingsMock: SettingsMock = SettingsMock()
    
    var sut: OpenEventService = OpenEventService()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = OpenEventService.init(logger: logMock, session: urlSessionMock, settings: settingsMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPostOpenEvent() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var request = OpenEventHttpRequest()
        
        request.integrationKey = settingsMock.getDengageIntegrationKey()
        request.messageDetails = ""
        request.messageId = 1
        
        sut.postOpenEvent(openEventHttpRequest: request)
    }
}
