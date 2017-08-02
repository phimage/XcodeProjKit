//
//  Dictionary+XcodeProjKit.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

extension Dictionary {

    mutating func updateValues(with dico: [Key: Value]) {
        for (key, value) in dico {
            self.updateValue(value, forKey: key)
        }
    }

    internal func key(_ keyString: String) throws -> String {
        guard let key = keyString as? Key, let val = self[key] as? String else {
            throw XcodeProjError.fieldMissing(key: keyString)
        }

        return val
    }

    internal func keys(_ keyString: String) throws -> [String] {
        guard let key = keyString as? Key, let val = self[key] as? [String] else {
            throw XcodeProjError.fieldMissing(key: keyString)
        }

        return val
    }

    internal func field<T>(_ keyString: String) throws -> T {
        guard let key = keyString as? Key, let val = self[key] as? T else {
            throw XcodeProjError.fieldMissing(key: keyString)
        }

        return val
    }

    internal func optionalField<T>(_ keyString: String) -> T? {
        guard let key = keyString as? Key else { return nil }

        return self[key] as? T
    }

    init(tuples: [(Key, Value)]) { /// xxx replace by uniqueKeysWithValues
        self.init(minimumCapacity: tuples.count)
        for (key, value) in tuples {
            self.updateValue(value, forKey: key)
        }
    }

}

func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    left.updateValues(with: right)
}
