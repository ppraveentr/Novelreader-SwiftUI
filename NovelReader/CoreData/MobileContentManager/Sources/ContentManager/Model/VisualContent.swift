//
//  VisualContent.swift
//  ContentManager
//
//  Created by Praveen Prabhakar on 9/3/24.
//  Copyright (c) 2024 Praveen P. All rights reserved.
//

import SwiftData

@Model
public class VisualContent {
    @Attribute(.unique) var identifier: String
    public var name: String
    public var lang: String
    public var content: String
    public var version: Double

    public init(name: String, lang: String, content: String, version: Double) {
        self.identifier = "\(name)-\(lang)"
        self.name = name
        self.lang = lang
        self.content = content
        self.version = version
    }
}
