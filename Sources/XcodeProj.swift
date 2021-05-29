//
//  XcodeProj.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class XcodeProj {

    public static let pbxprojFileExtension = "pbxproj"
    public static let pbxprojFileName = "project.pbxproj"

    public let dict: PBXObject.Fields
    public let format: PropertyListSerialization.PropertyListFormat
    public var projectName: String = "PRODUCT_NAME"
    public var lineEnding: String = "\r\n"

    public let project: PBXProject

    public class Objects: PBXObjectFactory {

        public var dict: [XcodeUUID: PBXObject] = [:]
        public var fullFilePaths: [XcodeUUID: PathType] = [:]

        public func object<T: PBXObject>(_ ref: String) -> T? {
            guard let obj = dict[ref] else {
                return nil
            }
            if let castedObj = obj as? T {
                return castedObj
            }
            return T(ref: ref, fields: obj.fields, objects: self)
        }

        public func remove<T: PBXObject>(_ object: T) {
            dict.removeValue(forKey: object.ref)
        }

        public func add<T: PBXObject>(_ object: T) {
            dict[object.ref] = object
        }

        #if LAZY
        lazy var buildPhaseByFileRef: [XcodeUUID: PBXBuildPhase] = {
            let buildPhases = self.dict.values.of(type: PBXBuildPhase.self)
            var dict: [String: PBXBuildPhase] = [:]
            for buildPhase in buildPhases {
                for file in buildPhase.files {
                    dict[file.ref] = buildPhase
                }
            }
            return dict
        }()
        #else
        var buildPhaseByFileRef: [XcodeUUID: PBXBuildPhase] {
            let buildPhases = self.dict.values.of(type: PBXBuildPhase.self)
            var dict: [String: PBXBuildPhase] = [:]
            for buildPhase in buildPhases {
                for file in buildPhase.files {
                    dict[file.ref] = buildPhase
                }
            }
            return dict
        }
        #endif

    }

    public let objects: Objects

    // MARK: init
    public convenience init(url: URL) throws {
        assert(url.isFileURL)

        let pbxprojURL = url.isDirectoryURL ?
            url.appendingPathComponent(XcodeProj.pbxprojFileName, isDirectory: false) : url

        do {
            let data = try Data(contentsOf: pbxprojURL)
            try self.init(propertyListData: data)

            if !url.isDirectoryURL, let str = String(data: data, encoding: .utf8) {

                if str.contains("\r\n") { // xxx very basic way to detect line ending...
                    lineEnding = "\r\n"
                } else {
                    lineEnding = "\n"
                }

                let entireRange = NSRange(location: 0, length: str.utf16.count)
                if let result = extractProjetNameRegex.firstMatch(in: str, options: [], range: entireRange) {
                    self.projectName = (str as NSString).substring(with: result.range)
                    self.projectName = String(self.projectName[
                        extractProjetName.endIndex..<self.projectName.index(self.projectName.endIndex, offsetBy: -1)])

                }
            }
        } catch let error as XcodeProjError {
            throw error
        } catch {
            throw XcodeProjError.failedToReadFile(error: error)
        }

        if url.isDirectoryURL {
            let subpaths = url.pathComponents
            if let last = subpaths.last, let range = last.range(of: ".xcodeproj") {
                self.projectName = String(last[...range.lowerBound])
            }
        }
    }

    public convenience init(propertyListData data: Data) throws {
        var format: PropertyListSerialization.PropertyListFormat = .binary
        let obj = try PropertyListSerialization.propertyList(from: data, options: [], format: &format)

        guard let dict = obj as? PBXObject.Fields else {
            throw XcodeProjError.invalidData(object: obj)
        }

        try self.init(dict: dict, format: format)
    }

    init(dict: PBXObject.Fields, format: PropertyListSerialization.PropertyListFormat) throws {
        self.dict = dict
        self.format = format

        self.objects = Objects()

        if let objs = self.dict[FieldKey.objects.rawValue] as? [String: PBXObject.Fields] {
            // Create all objects
            for (ref, obj) in objs {
                self.objects.dict[ref] = try XcodeProj.createObject(ref: ref, fields: obj, objects: self.objects)
            }

            // parsing project
            if let rootObjectRef = self.dict[FieldKey.rootObject.rawValue] as? String {
                if let projDict = objs[rootObjectRef] {
                    self.project = PBXProject(ref: rootObjectRef, fields: projDict, objects: self.objects)
                    if let mainGroup = self.project.mainGroup {
                        objects.fullFilePaths = paths(mainGroup, prefix: "")
                    } else {
                        if let mainGroupref = self.project.string(PBXProject.PBXKeys.mainGroup) {
                            throw XcodeProjError.objectMissing(key: mainGroupref, expectedType: .group)
                        } else {
                            throw XcodeProjError.fieldKeyMissing(.mainGroup)
                        }
                    }
                } else {
                    throw XcodeProjError.objectMissing(key: rootObjectRef, expectedType: .project)
                }
            } else {
                throw XcodeProjError.fieldKeyMissing(.rootObject)
            }
        } else {
            throw XcodeProjError.fieldKeyMissing(.objects)
        }
    }

    static func createObject(ref: String, fields: PBXObject.Fields, objects: XcodeProj.Objects) throws -> PBXObject {
        guard let isa = fields[FieldKey.isa.rawValue] as? String else {
            throw XcodeProjError.fieldKeyMissing(.isa)
        }
        if let type = Isa(rawValue: isa)?.type {
            return type.init(ref: ref, fields: fields, objects: objects)
        }
        assertionFailure("Unknown isa=\(isa)")
        return PBXObject(ref: ref, fields: fields, objects: objects)
    }

}

let extractProjetName = "Build configuration list for PBXProject \""
// swiftlint:disable:next force_try
let extractProjetNameRegex = try! NSRegularExpression(pattern:
    "Build configuration list for PBXProject \"(.*)\"", options: [])

extension XcodeProj: PBXObjectFactory {
    public func object<T>(_ ref: String) -> T? where T: PBXObject {
        return self.objects.object(ref)
    }
    public func remove<T: PBXObject>(_ object: T) {
        self.objects.remove(object)
    }
    public func add<T: PBXObject>(_ object: T) {
        self.objects.add(object)
    }
}
