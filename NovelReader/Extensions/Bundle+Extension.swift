//
//  Bundle+Extension.swift
//  NovelReader
//
//  Created by Praveen Prabhakar on 2/16/25.
//

import SwiftUI

extension Bundle {
    private final class Utility { }

    static var MainBundle: Bundle {
        Bundle(for: Utility.self)
    }
}
