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

    let sut = Utilities.shared
    let storage = DengageLocalStorage.shared
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIfStorageReturnsNilGetIdentifierForApplication(){
        
        //TODO : mock storage
        storage.setValueWithKey(value: "", key: "ApplicationIdentifier")
        
        let actual = sut.identifierForApplication()
        
        XCTAssertNotNil(actual)
        
    }

}
