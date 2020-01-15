//
//  EventCollectionServiceTestCase.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class EventCollectionServiceTestCase: XCTestCase {

    var logMock : SDKLoggerMock = SDKLoggerMock()
    var urlSessionMock : URLSessionMock = URLSessionMock()
    var settingsMock : SettingsMock = SettingsMock()
    
    var sut : EventCollectionService = EventCollectionService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = EventCollectionService.init(logger: logMock, session: urlSessionMock, settings: settingsMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var data = EventCollectionModel()
        
        data.eventDetails = [] as Any as? NSDictionary
        data.eventTable = "table"
        data.key = "key"
    
        
        sut.PostEventCollection(eventCollectionModel: data)
    }

  

}
