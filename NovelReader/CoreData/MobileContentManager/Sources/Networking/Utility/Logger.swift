//
//  Logger.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 30/09/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public func ftLog(_ arg: Any ...) {
    if Logger.enableConsoleLogging {
        debugPrint(arg)
    }
}

public class Logger {
    public static var enableConsoleLogging = false
}
