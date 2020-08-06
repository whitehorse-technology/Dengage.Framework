//
//  BaseService.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 16.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import Dengage_Framework

class BaseServiceTestCase: XCTestCase {
    
    var logMock: SDKLoggerMock = SDKLoggerMock()
    var urlSessionMock: URLSessionMock = URLSessionMock()
    var settingsMock: SettingsMock = SettingsMock()
    
    var sut: BaseService = BaseService.init()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = BaseService.init(logger: logMock, session: urlSessionMock, settings: settingsMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApiCall() {
        
        let parameters = [] as Any
        
        sut.apiCall(data: parameters, urlAddress: "https://pushdev.dengage.com/api/subscription")
        
    }
}
