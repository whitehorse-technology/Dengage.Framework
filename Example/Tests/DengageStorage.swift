//
//  DengageStorageTestCase.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 12.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Dengage_Framework

class DengageStorageTestCase: XCTestCase {
    
    let sut = DengageLocalStorage.shared

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetValueWithKey(){
        
        sut.setValueWithKey(value: "1", key: "test")
        
        let actual = sut._userDefaults.string(forKey: "test")
        
        XCTAssertEqual("1", actual)
    }
    
    func testGetValueWithKey(){
        
        sut.setValueWithKey(value: "1", key: "test")
        let actual = sut.getValueWithKey(key: "test")
        
        XCTAssertEqual("1", actual)
    }
    
    func testGetValueWithKeyReturnsNil(){
        
        sut.setValueWithKey(value: "1", key: "test")
        let actual = sut.getValueWithKey(key: "test_key")
        
        XCTAssertNil(actual)
    }

}
