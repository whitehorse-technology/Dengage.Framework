//
//  NotificationExtensionTests.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 13.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import Dengage_Framework

class NotificationExtensionTests: XCTestCase {

    var logMock : SDKLoggerMock = SDKLoggerMock()
    
    var sut : DengageNotificationExtension?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = DengageNotificationExtension.init(logger: logMock)
        
        logMock.setIsDisabled(isDisabled: false)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testdidReceiveNotificationExtentionRequest_If_MessageSource_Is_Nil_DoNothing(){
        
        let mutableNotificationContent = UNMutableNotificationContent()
        
        let notificationRequest = UNNotificationRequest.init(identifier: "request", content: mutableNotificationContent, trigger: nil)
        sut!.didReceiveNotificationExtentionRequest(receivedRequest: notificationRequest, withNotificationContent: mutableNotificationContent)
        
    }
    

}
