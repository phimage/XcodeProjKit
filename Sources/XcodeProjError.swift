//
//  XcodeProjError.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public struct AnySendable: @unchecked Sendable {
    let value: Any?
}

public enum XcodeProjError: Error {

    // Data not a dictionary
    case invalidData(object: AnySendable)

    // Missing field
    case fieldMissing(key: String)

    // Failed to read\
    case failedToReadFile(error: Error)

    // object missing
    case objectMissing(key: String, expectedType: Isa?)

}
