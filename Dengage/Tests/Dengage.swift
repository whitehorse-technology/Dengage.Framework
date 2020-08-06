//
//  Dengage.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class DengageTestCase : XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Dengage.settings = SettingsMock()
        Dengage.logger = SDKLoggerMock()
        Dengage.utilities = UtilitiesMock()
        
        Dengage.subscriptionService = SubscriptionServiceMock()
        Dengage.openEventService = OpenEventServiceMock()
        Dengage.eventCollectionService = EventCollectionServiceMock()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConfigureSettings() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        Dengage.ConfigureSettings()
    }
        
    func testSyncSubscription() {
        
        Dengage.SyncSubscription()
    }
    
    func testIfAdvertisinIdIsEmptyReturnVoid() {
        
        Dengage.settings = SettingMockForThisCase()
        Dengage.settings.setAdvertisingId(advertisingId: "")
        Dengage.SyncSubscription()
    }
    
    func testIfApplicaitonIdentifierIsEmptyReturnVoid() {
        
        Dengage.settings = SettingMockForThisCase()
        Dengage.settings.setAdvertisingId(advertisingId: "10000-10111-110101-1010")
        Dengage.settings.setApplicationIdentifier(applicationIndentifier: "")
        Dengage.SyncSubscription()
    }
    
    func testGetDeviceId() {
        
        Dengage.settings = SettingMockForThisCase()
        Dengage.settings.setApplicationIdentifier(applicationIndentifier: "10101-101-011-101001-10101-1010")
        let actual = Dengage.getDeviceId()
        
        XCTAssertEqual("10101-101-011-101001-10101-1010", actual)
    }
    
    func testSetLogStatus() {
        
        Dengage.setLogStatus(isVisible: false)
    }
    
    func testsetUserPermission() {
        
        Dengage.setUserPermission(permission: true)
    }
    
    func testsetToken() {
        
        Dengage.settings = SettingMockForThisCase()
        Dengage.setToken(token: "token")
        
        let actual = Dengage.settings.getToken()
        
        XCTAssertEqual("token", actual)
    }
    
    func testsetContactKey() {
        
        Dengage.settings = SettingMockForThisCase()
        Dengage.setContactKey(contactKey: "contactkey")
        
        let actual = Dengage.settings.getContactKey()
        
        XCTAssertEqual("contactkey", actual)
    }
    
    func testsetIntegrationKey() {
        
        Dengage.settings = SettingMockForThisCase()
        Dengage.setIntegrationKey(key: "111112")
        
        let actual = Dengage.settings.getDengageIntegrationKey()
        
        XCTAssertEqual("111112", actual)
        XCTAssertNotEqual("111111", actual)
        
    }
    
    func initWithLaunchOptions() {
        
        Dengage.initWithLaunchOptions(withLaunchOptions: .none, badgeCountReset: true)
    }
    
    func testSyncEventQueues() {
        
        let eventCollection :  [EventCollectionModel] = [EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel()]
        
        for event in eventCollection {
            
            Dengage.syncEventQueues(eventCollectionModel: event)
        }
        
        let actual = Dengage.eventQueue.items.count
        
        XCTAssertEqual(3, actual)
    }
    
}

class SettingMockForThisCase : Settings {
    
    var appIdentifer : String!
    var advertisingId : String!
    
    override func getApplicationIdentifier() -> String {
        return appIdentifer
    }
    
    override func setApplicationIdentifier(applicationIndentifier: String) {
        
        appIdentifer = applicationIndentifier
    }
    
    override func getAdvertisinId() -> String? {
        return advertisingId
    }
    
    override func setAdvertisingId(advertisingId: String) {
        self.advertisingId = advertisingId
    }
}
