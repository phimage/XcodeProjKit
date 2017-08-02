//
//  FieldKey.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public enum FieldKey: String {
    case isa

    case objects
    case rootObject

    case mainGroup
}

extension XcodeProjError {

    static func fieldKeyMissing(_ key: FieldKey) -> XcodeProjError {
        return .fieldMissing(key: key.rawValue)
    }

}
