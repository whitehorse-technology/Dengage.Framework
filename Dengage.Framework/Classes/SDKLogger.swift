//
//  Logger.swift
//  dengage.ios.sdk
//
//  Created by Developer on 26.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import os.log

internal class SDKLogger {

    private var isVisiable: Bool = false
    static let shared = SDKLogger()

    init() {}

    internal func setIsDisabled(isDisabled: Bool) {

        self.isVisiable = isDisabled
    }

    internal func Log(message: StaticString, logtype: OSLogType, argument: String) {
        guard isVisiable else { return }
        os_log(message, log: .default, type: logtype, argument)
    }

    internal func Log(message: StaticString, logtype: OSLogType) {
        guard isVisiable else { return }
        os_log(message, log: .default, type: logtype)
    }
}
