//
//  TransactioanlOpenEventService.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class TransactioanlOpenEventServiceTestCase: XCTestCase {

    var logMock: SDKLoggerMock = SDKLoggerMock()
    var urlSessionMock: URLSessionMock = URLSessionMock()
    var settingsMock: SettingsMock = SettingsMock()
    
    var sut: TransactioanlOpenEventService = TransactioanlOpenEventService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TransactioanlOpenEventService.init(logger: logMock, session: urlSessionMock, settings: settingsMock)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPostOpenEvent() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var request = TransactionalOpenEventHttpRequest()
        
        request.integrationId = settingsMock.getDengageIntegrationKey()
        request.transactionId = ""
        request.messageDetails = ""
        request.messageId = 1
        
        sut.postOpenEvent(transactionalOpenEventHttpRequest: request)
    }
}
