//
//  MDProductGroupsModel.swift
//  grocy-ios
//
//  Created by Georg Meissner on 13.10.20.
//

import Foundation

// MARK: - MDProductGroup
struct MDProductGroup: Codable {
    let id, name, mdProductGroupDescription, rowCreatedTimestamp: String
    let userfields: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case mdProductGroupDescription = "description"
        case rowCreatedTimestamp = "row_created_timestamp"
        case userfields
    }
}

struct MDProductGroupPOST: Codable {
    let id: Int
    let name, mdProductGroupDescription, rowCreatedTimestamp: String
    let userfields: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case mdProductGroupDescription = "description"
        case rowCreatedTimestamp = "row_created_timestamp"
        case userfields
    }
}

typealias MDProductGroups = [MDProductGroup]
