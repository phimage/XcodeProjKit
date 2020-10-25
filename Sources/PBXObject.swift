//
//  PBXObject.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public typealias XcodeUUID = String
public typealias PBXKey = String

public /* abstract */ class PBXObject {
    public typealias Fields = [String: Any]

    public let ref: XcodeUUID
    public var fields: PBXObject.Fields
    let objects: PBXObjectFactory

    public enum PBXKeys: PBXKey {
        case isa
    }

    #if LAZY
    public lazy var isa: Isa = Isa(rawValue: self.string("isa")!)!
    #else
    public var isa: Isa { Isa(rawValue: self.string("isa")!)! }
    #endif

    public required init(ref: XcodeUUID, fields: PBXObject.Fields = [:], objects: PBXObjectFactory) {
        self.ref = ref
        self.fields = fields
        self.objects = objects
        if self.fields[PBXKeys.isa.rawValue] == nil {
            self.fields[PBXKeys.isa.rawValue] = String(describing: type(of: self))
        }
    }

    public var comment: String? {
        return self.isa.rawValue
    }

}

extension PBXObject {

    fileprivate func bool(_ key: String) -> Bool? {
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

    fileprivate func bool(_ key: String) -> Bool {
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

    fileprivate func string(_ key: String) -> String? {
        guard let value = fields[key] as? String else {
            return nil // missing path
        }
        return value
    }

    fileprivate func string(_ key: String) -> String {
        guard let value = fields[key] as? String else {
            assertionFailure("Missing field \(key) for \(self)")
          return ""
        }
        return value
    }

    fileprivate func strings(_ key: String) -> [String] {
        guard let value = fields[key] as? [String] else {
            assertionFailure("Missing field \(key) for \(self)")
            return []
        }
        return value
    }

    fileprivate func dictionary<Key, Value>(_ key: String) -> [Key: Value]? {
        guard let value = fields[key] as? [Key: Value] else {
            return nil // missing path
        }
        return value
    }

    func string<R: RawRepresentable>(_ key: R) -> String? where R.RawValue == String {
        return string(key.rawValue)
    }

    func string<R: RawRepresentable>(_ key: R) -> String where R.RawValue == String {
        return string(key.rawValue)
    }

    func strings<R: RawRepresentable>(_ key: R) -> [String] where R.RawValue == String {
         return strings(key.rawValue)
    }

    func bool<R: RawRepresentable>(_ key: R) -> Bool where R.RawValue == String {
        return bool(key.rawValue)
    }

    func dictionary<Key, Value, R: RawRepresentable>(_ key: R) -> [Key: Value]? where R.RawValue == String {
        return dictionary(key.rawValue)
    }
}

public protocol PBXObjectFactory {
    func object<T: PBXObject>(_ ref: XcodeUUID) -> T?
    func remove<T: PBXObject>(_ object: T)
    func add<T: PBXObject>(_ object: T)
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

    func object<T: PBXObject, R: RawRepresentable>(_ key: R) -> T? where R.RawValue == String {
        return object(key.rawValue)
    }

    func objects<T: PBXObject, R: RawRepresentable>(_ key: R) -> [T] where R.RawValue == String {
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

    public func set(value: Any, into key: String) {
        fields[key] = value
    }

    public func remove<R: RawRepresentable>(forKey key: R) where R.RawValue == String {
        fields.removeValue(forKey: key.rawValue)
    }

    public func remove<T: PBXObject, R: RawRepresentable>(object: T, forKey key: R) where R.RawValue == String {
        if var objectKeys = fields[key.rawValue] as? [String] {
            objectKeys.removeAll(where: { $0 == object.ref})
            fields[key.rawValue] = objectKeys
        }
    }

    public func add<T: PBXObject, R: RawRepresentable>(object: T, into key: R) where R.RawValue == String {
        if var objectKeys = fields[key.rawValue] as? [String] {
            objectKeys.append(object.ref)
            fields[key.rawValue] = objectKeys
        }
    }

    public func set<T: PBXObject, R: RawRepresentable>(object: T, into key: R) where R.RawValue == String {
        fields[key.rawValue] = object.ref
    }

    public func set<R: RawRepresentable>(value: Any, into key: R) where R.RawValue == String {
        fields[key.rawValue] = value
    }

    public func unattach() {
        objects.remove(self)
    }

    public func attach() {
        objects.add(self)
    }
}

extension PBXObject: CustomStringConvertible {

    public var description: String {
        return "\(type(of: self)): [id: \(ref), fields: \(fields)]"
    }
}

extension PBXObject: Equatable {
    public static func == (lhs: PBXObject, rhs: PBXObject) -> Bool {
        return lhs.ref == rhs.ref && type(of: lhs) == type(of: rhs)
    }
}
