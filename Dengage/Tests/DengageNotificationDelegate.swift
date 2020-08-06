//
//  DengageNotificationDelegateTestCase.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class DengageNotificationDelegateTestCase: XCTestCase {
    
    var openEventServiceMock: OpenEventServiceMock = OpenEventServiceMock()
    var transactionalOpenEventServiceMock: TransactioanlOpenEventServiceMock = TransactioanlOpenEventServiceMock()
    var settingsMock: SettingsMock = SettingsMock()
    
    var sut : DengageNotificationDelegate = DengageNotificationDelegate()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = DengageNotificationDelegate(settings: settingsMock,
                                          openEventService: openEventServiceMock,
                                          transactionalOpenEventService: transactionalOpenEventServiceMock)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testsendOpenEvent() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        sut.sendOpenEvent(messageId: 1, messageDetails: "", buttonId: "")
    }
    
    func testsendTransactionalOpenEvent() {
        
        sut.sendTransactionalOpenEvent(messageId: 1, transactionId: "", messageDetails: "", buttonId: "")
    }
    
    func testsendEventWithContent() {
        
        let mock = UNNotificationContent()
        
        sut.sendEventWithContent(content: mock,actionIdentifier: "")
    } 
}



