//
//  Dictionary+Extension.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 01/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public extension Dictionary {
    func keyPath<T>(_ keyPath: String) -> T? {
        (self as NSDictionary).value(forKeyPath: keyPath) as? T
    }
}

// swiftlint:disable static_operator
// MARK: Dictionary:
// Operator '+' Overloading
public func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
    var computedValue = left

    for (key, value) in right {
        var superObject: [K: V]? = left[key] as? [K: V]
        let subObject = value as? [K: V]

        if subObject != nil, superObject != nil {
            superObject! += subObject!
            computedValue[key]! = (superObject as? V)!
        } else {
            computedValue[key] = value
        }
    }

    return computedValue
}

// Operator Overloading
public func += <K, V> (left: inout [K: V], right: [K: V]) {
    for (key, value) in right {
        left[key] = value
    }
}

public func += <K, V> (left: inout [K: V], right: [K: V]) where V: RangeReplaceableCollection {
    for (key, value) in right {
        if let collection = left[key] {
            left[key] = collection + value
        } else {
            left[key] = value
        }
    }
}

// MARK: Array
public func += <K> ( left: inout [K], right: [K]) {
    for (key) in right {
        left.append(key)
    }
}
// swiftlint:enable static_operator
