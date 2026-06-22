//
//  GenresModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import SwiftData

@Model
public class GenresModel {
    @Attribute(.unique) public private(set) var identifier: String
    public var name: String

    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
