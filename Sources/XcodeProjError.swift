//
//  XcodeProjError.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public enum XcodeProjError: Error {

    // Data not a dictionary
    case invalidData(object: Any)

    // Missing field
    case fieldMissing(key: String)

    // Failed to read\
    case failedToReadFile(error: Error)

    // object missing
    case objectMissing(key: String, expectedType: Isa?)

    // not supported
    case notSupported

}
