//
//  PBXObject.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public typealias XcodeUUID = String

public /* abstract */ class PBXObject {
    public typealias Fields = [String: Any]

    let ref: XcodeUUID
    var fields: PBXObject.Fields
    let objects: PBXObjectFactory

    #if LAZY
    public lazy var isa: Isa = Isa(rawValue: self.string("isa")!)!
    #else
    public var isa: Isa { Isa(rawValue: self.string("isa")!)! }
    #endif

    public required init(ref: XcodeUUID, fields: PBXObject.Fields, objects: PBXObjectFactory) {
        self.ref = ref
        self.fields = fields
        self.objects = objects
    }

    public var comment: String? {
        return self.isa.rawValue
    }

}

extension PBXObject {

    func bool(_ key: XcodeUUID) -> Bool? {
        guard let string = fields[key] as? String else {
            return nil // missing path
        }

        switch string {
        case "0":
            return false
        case "1":
            return true
        default:
            return nil
        }
    }

    func bool(_ key: XcodeUUID) -> Bool {
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

    func string(_ key: XcodeUUID) -> String? {
        guard let value = fields[key] as? String else {
            return nil // missing path
        }
        return value
    }

    func string(_ key: XcodeUUID) -> String {
        guard let value = fields[key] as? String else {
            assertionFailure("Missing field \(key) for \(self)")
          return ""
        }
        return value
    }

    func strings(_ key: XcodeUUID) -> [String] {
        guard let value = fields[key] as? [String] else {
            assertionFailure("Missing field \(key) for \(self)")
            return []
        }
        return value
    }

    func string(_ key: FieldKey) -> String? {
        return string(key.rawValue)
    }

    func dictionary<Key, Value>(_ key: XcodeUUID) -> [Key: Value]? {
        guard let value = fields[key] as? [Key: Value] else {
            return nil // missing path
        }
        return value
    }

}

public protocol PBXObjectFactory {
    func object<T: PBXObject>(_ ref: XcodeUUID) -> T?
    func remove<T: PBXObject>(_ object: T)
}

extension PBXObject {

    public func object<T: PBXObject>(_ key: String) -> T? {
        guard let objectKey = fields[key] as? String else {
            return nil
        }

        let obj: T? = objects.object(objectKey)
        return obj
    }

    func objects<T: PBXObject>(_ key: String) -> [T] {
        guard let objectKeys = fields[key] as? [String] else {
            return []
        }

        return objectKeys.compactMap(objects.object)
    }

    func object<T: PBXObject>(_ key: FieldKey) -> T? {
        return object(key.rawValue)
    }

    func objects<T: PBXObject>(_ key: FieldKey) -> [T] {
        return objects(key.rawValue)
    }

}

extension PBXObject {

    public func remove(forKey key: String) {
        fields.removeValue(forKey: key)
    }

    public func remove<T: PBXObject>(object: T, forKey key: String) {
        if var objectKeys = fields[key] as? [String] {
            objectKeys.removeAll(where: { $0 == object.ref})
            fields[key] = objectKeys
        }
    }

    public func add<T: PBXObject>(object: T, into key: String) {
        if var objectKeys = fields[key] as? [String] {
            objectKeys.append(object.ref)
            fields[key] = objectKeys
        }
    }

    public func set<T: PBXObject>(object: T, into key: String) {
        fields[key] = object.ref
    }

    public func destroy() {
        objects.remove(self)
    }

}

extension PBXObject: CustomStringConvertible {

    public var description: String {
        return "\(type(of: self)): [id: \(ref), fields: \(fields)]"
    }
}
