//
//  GenresModel+ServiceHelper.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 6/29/25.
//

import SwiftData
import Foundation

extension GenresModel {
    convenience init(service: ServiceGenresModel) {
        self.init(identifier: service.identifier, name: service.name)
    }
}
