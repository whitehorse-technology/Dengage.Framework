//
//  MockClasses.swift
//  Dengage.Framework_Tests
//
//  Created by Ekin Bulut on 13.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import AdSupport
import CoreTelephony
@testable import Dengage_Framework


class ASIdentifierManagerMock : ASIdentifierManager{
    
    
}


class DengageLocalStorageMock : DengageLocalStorage{
    
    var value : String = ""
    
    
    override func setValueWithKey(value: String, key: String) {
        self.value = value
    }
    
    override func getValueWithKey(key: String) -> String? {
        return nil
    }
}

class SDKLoggerMock : SDKLogger{
    
    
    
}

class CTTelephonyNetworkInfoMock : CTTelephonyNetworkInfo{
    
    
}

class CTCarrierMock : CTCarrier{
    
    
    
}
