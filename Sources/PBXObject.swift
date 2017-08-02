//
//  PBXObject.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public typealias UUID = String

public /* abstract */ class PBXObject {
    public typealias Fields = [String: Any]

    let ref: UUID
    let fields: PBXObject.Fields
    let objects: PBXObjectFactory

    public lazy var isa: Isa = Isa(rawValue: self.string("isa")!)!

    public required init(ref: UUID, fields: PBXObject.Fields, objects: PBXObjectFactory) {
        self.ref = ref
        self.fields = fields
        self.objects = objects
    }

    public var comment: String? {
        return self.isa.rawValue
    }

}

extension PBXObject {

    func bool(_ key: UUID) -> Bool {
        guard let string = fields[key] as? String else {
            assertionFailure("Missing field \(key) for \(self)")
            return false
        }

        switch string {
        case "0":
            return false
        case "1":
            return true
        default:
            return false
        }
    }

    func string(_ key: UUID) -> String? {
        guard let value = fields[key] as? String else {
            return nil // missing path
        }
        return value
    }

    func strings(_ key: UUID) -> [String] {
        guard let value = fields[key] as? [String] else {
            assertionFailure("Missing field \(key) for \(self)")
            return []
        }
        return value
    }

    func string(_ key: FieldKey) -> String? {
        return string(key.rawValue)
    }

}

public protocol PBXObjectFactory {
    func object<T: PBXObject>(_ ref: UUID) -> T?
}

public extension PBXObjectFactory {
    func object<T: PBXObject>(_ key: FieldKey) -> T? {
        return object(key.rawValue)
    }
}

extension PBXObject: PBXObjectFactory {

    public func object<T: PBXObject>(_ key: UUID) -> T? {
        guard let objectKey = fields[key] as? String else {
            return nil
        }

        let obj: T? = objects.object(objectKey)
        return obj
    }

    func objects<T: PBXObject>(_ key: UUID) -> [T] {
        guard let objectKeys = fields[key] as? [String] else {
            return []
        }

        return objectKeys.flatMap(objects.object)
    }

    func objects<T: PBXObject>(_ key: FieldKey) -> [T] {
        return objects(key.rawValue)
    }

}
