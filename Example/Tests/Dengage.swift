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
        Dengage._settings = SettingsMock()
        Dengage._logger = SDKLoggerMock()
        Dengage._utilities = UtilitiesMock()
        
        Dengage._subscriptionService = SubscriptionServiceMock()
        Dengage._openEventService = OpenEventServiceMock()
        Dengage._eventCollectionService = EventCollectionServiceMock()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConfigureSettings() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        Dengage.ConfigureSettings()
    }
    
    func testSendCustomEvent(){
        
        let actual = Dengage.SendCustomEvent(toEventTable: "test", withKey: "", andWithEventDetails: ["":""])
        
        XCTAssertTrue(actual)
    }
    
    func testIfSendCustomEventToEventTableIsEmpty(){
        let actual = Dengage.SendCustomEvent(toEventTable: "", withKey: "", andWithEventDetails: ["":""])
        
        XCTAssertFalse(actual)
    }

    func testIfSendCustomEventIntegrationKeyIsEmpty(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage._settings.setDengageIntegrationKey(integrationKey: "")
        let actual = Dengage.SendCustomEvent(toEventTable: "event", withKey: "", andWithEventDetails: ["":""])
        
        XCTAssertFalse(actual)
    }
    
    
    func testSendDeviceEvent(){
        
        let actual = Dengage.SendDeviceEvent(toEventTable: "test", andWithEventDetails: ["":""])
        
        XCTAssertTrue(actual)
    }
    
    func testIfSendDeviceEventToEventTableIsEmpty(){
        let actual = Dengage.SendDeviceEvent(toEventTable: "", andWithEventDetails: ["":""])
        
        XCTAssertFalse(actual)
    }

    func testIfSendDeviceEventIntegrationKeyIsEmpty(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage._settings.setDengageIntegrationKey(integrationKey: "")
        let actual = Dengage.SendDeviceEvent(toEventTable: "event", andWithEventDetails: ["":""])
        
        XCTAssertFalse(actual)
    }
    
    func testSyncSubscription(){
        
        Dengage.SyncSubscription()
    }
    
    func testIfAdvertisinIdIsEmptyReturnVoid(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage._settings.setAdvertisingId(advertisingId: "")
        Dengage.SyncSubscription()
    }
    
    func testIfApplicaitonIdentifierIsEmptyReturnVoid(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage._settings.setAdvertisingId(advertisingId: "10000-10111-110101-1010")
        Dengage._settings.setApplicationIdentifier(applicationIndentifier: "")
        Dengage.SyncSubscription()
    }
    
    func testGetDeviceId(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage._settings.setApplicationIdentifier(applicationIndentifier: "10101-101-011-101001-10101-1010")
        let actual = Dengage.getDeviceId()
        
        XCTAssertEqual("10101-101-011-101001-10101-1010", actual)
    }
    
    func testSetLogStatus(){
        
        Dengage.setLogStatus(isVisible: false)
    }
    
    func testsetUserPermission(){
        
        Dengage.setUserPermission(permission: true)
    }
    
    func testsetToken(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage.setToken(token: "token")

        let actual = Dengage._settings.getToken()
        
        XCTAssertEqual("token", actual)
    }
    
    func testsetContactKey(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage.setContactKey(contactKey: "contactkey")

        let actual = Dengage._settings.getContactKey()
        
        XCTAssertEqual("contactkey", actual)
    }
    
    func testsetIntegrationKey(){
        
        Dengage._settings = SettingMockForThisCase()
        Dengage.setIntegrationKey(key: "111112")

        let actual = Dengage._settings.getDengageIntegrationKey()
               
        XCTAssertEqual("111112", actual)
        XCTAssertNotEqual("111111", actual)
        
    }
    
    func initWithLaunchOptions(){
        
        Dengage.initWithLaunchOptions(withLaunchOptions: .none, badgeCountReset: true)
    }
    
    func testSyncEventQueues(){
        
        let eventCollection :  [EventCollectionModel] = [EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel(),
                                                         EventCollectionModel()]
        
        for event in eventCollection {
            
            Dengage.SyncEventQueues(eventCollectionModel: event)
        }
        
        let actual = Dengage._eventQueue.items.count
        
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
