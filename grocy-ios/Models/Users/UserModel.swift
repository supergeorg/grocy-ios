//
//  UserModel.swift
//  grocy-ios
//
//  Created by Georg Meissner on 12.10.20.
//

import Foundation

public struct User: Codable {

    public let _id: Int?
    public let username: String?
    public let firstName: String?
    public let lastName: String?
    public let password: String?
    public let rowCreatedTimestamp: Date?

    public init(_id: Int?, username: String?, firstName: String?, lastName: String?, password: String?, rowCreatedTimestamp: Date?) {
        self._id = _id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.rowCreatedTimestamp = rowCreatedTimestamp
    }

    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case password
        case rowCreatedTimestamp = "row_created_timestamp"
    }
}

/// A user object without the *password* and with an additional *display_name* property
public struct UserDto: Codable {

//    Die API ist Falsch, gibt immer ein String zurück
//    public let _id: Int?
    public let _id: String?
    public let username: String?
    public let firstName: String?
    public let lastName: String?
    public let displayName: String?
//    Das Datumsformat auch?
//    public let rowCreatedTimestamp: Date?
    public let rowCreatedTimestamp: String?

    public init(_id: String?, username: String?, firstName: String?, lastName: String?, displayName: String?, rowCreatedTimestamp: String?) {
        self._id = _id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName
        self.rowCreatedTimestamp = rowCreatedTimestamp
    }

    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_name"
        case rowCreatedTimestamp = "row_created_timestamp"
    }
}
