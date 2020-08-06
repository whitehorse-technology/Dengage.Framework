//
//  UtilitiesTestCase.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 12.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import Dengage_Framework

class UtilitiesTestCase: XCTestCase {
    
    var storageMock: DengageLocalStorageMock =  DengageLocalStorageMock(suitName: "")
    var ctTelephonyNetworkInfoMock: CTTelephonyNetworkInfoMock = CTTelephonyNetworkInfoMock()
    var logMock: SDKLoggerMock = SDKLoggerMock()
    var asIdentifierManagerMock: ASIdentifierManagerMock = ASIdentifierManagerMock()
    var sut: Utilities = Utilities.init()
    
    override func setUp() {
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        
        sut = Utilities.init(storage: storageMock,
                             logger: logMock,
                             asIdentifierManager: asIdentifierManagerMock,
                             ctTelephonyNetworkInfo: ctTelephonyNetworkInfoMock)
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfStorageReturnsNilGetIdentifierForApplication() {
        
        //let sut = Utilities.init(storage: storageMock, logger: logMock, asIdentifierManager: asIdentifierManagerMock)
        
        let actual = sut.identifierForApplication()
        
        XCTAssertNotNil(actual)
        
    }
    
    func testIfIsAdvertisingTrackingEnabledGenerateAdvertisingId() {
        
        let actual = sut.identifierForAdvertising()
        
        XCTAssertNotNil(actual)
    }
    
    func testIdentifierForCarrier() {
        
        let actual = sut.identifierForCarrier()
        
        XCTAssertEqual("1", actual)
    }
    
}
