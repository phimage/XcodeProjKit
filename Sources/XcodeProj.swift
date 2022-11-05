//
//  XcodeProj.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class XcodeProj: PropertyList {

    public static let pbxprojFileExtension = "pbxproj"
    public static let pbxprojFileName = "project.pbxproj"

    public var projectName: String = "PRODUCT_NAME"
    public var lineEnding: String = "\r\n"

    public let objects: Objects
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

    // MARK: init
    public convenience init(url: URL) throws {
        assert(url.isFileURL)

        let pbxprojURL = url.isDirectoryURL ?
            url.appendingPathComponent(XcodeProj.pbxprojFileName, isDirectory: false) : url

        do {
            let data = try Data(contentsOf: pbxprojURL)
            try self.init(propertyListData: data)

            if let str = String(data: data, encoding: .utf8) {
                if str.contains("\r\n") { // xxx very basic way to detect line ending...
                    lineEnding = "\r\n"
                } else {
                    lineEnding = "\n"
                }
                if !url.isDirectoryURL {
                    let entireRange = NSRange(location: 0, length: str.utf16.count)
                    if let result = extractProjetNameRegex.firstMatch(in: str, options: [], range: entireRange) {
                        self.projectName = (str as NSString).substring(with: result.range)
                        self.projectName = String(self.projectName[
                            extractProjetName.endIndex..<self.projectName.index(self.projectName.endIndex, offsetBy: -1)])

                    }
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
                self.projectName = String(last[..<range.lowerBound])
            }
        }
    }

    public convenience init(dict: PBXObject.Fields, format: PropertyListSerialization.PropertyListFormat) throws {
        try self.init(dict: dict, format: .init(format))
    }

    public override init(dict: PBXObject.Fields, format: Format) throws {
        self.objects = Objects()

        if let objs = dict[FieldKey.objects.rawValue] as? [String: PBXObject.Fields] {
            // Create all objects
            for (ref, obj) in objs {
                self.objects.dict[ref] = try XcodeProj.createObject(ref: ref, fields: obj, objects: self.objects)
            }

            // parsing project
            if let rootObjectRef = dict[FieldKey.rootObject.rawValue] as? String {
                if let projDict = objs[rootObjectRef] {
                    self.project = PBXProject(ref: rootObjectRef, fields: projDict, objects: self.objects)
                    if let mainGroup = self.project.mainGroup {
                        objects.fullFilePaths = XcodeProj.paths(mainGroup, prefix: "")
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
        try super.init(dict: dict, format: format)
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

    public override func write(to url: URL,
                               format: Format? = nil,
                               projectName: String? = nil,
                               lineEnding: String? = nil,
                               atomic: Bool = true) throws {
        let pbxprojURL: URL
        let name: String
        if url.isDirectoryURL {
            pbxprojURL = url.appendingPathComponent(XcodeProj.pbxprojFileName, isDirectory: false)
            let subpaths = url.pathComponents
            if let projectName = projectName {
                name = projectName
            } else {
                // Find in project
                if let last = subpaths.last, let range = last.range(of: ".xcodeproj") {
                    name = String(last[..<range.lowerBound])
                } else {
                    name = self.projectName // default
                }
            }
        } else {
            pbxprojURL = url
            name = projectName ?? self.projectName
        }
        let lineEnding = lineEnding ?? self.lineEnding
        let format = format ?? self.format
        if format == .openStep {
            let serializer = OpenStepSerializer(projectName: name, lineEnding: lineEnding, projectFile: self)
            try serializer.serialize().write(to: pbxprojURL, atomically: atomic, encoding: .utf8)
        } else {
            try super.write(to: pbxprojURL,
                            format: format,
                            projectName: projectName,
                            lineEnding: lineEnding,
                            atomic: atomic)
        }
    }

    public override func data(projectName: String? = nil) throws -> Data {
        if format == .openStep {
            let projectName = projectName ?? self.projectName
            let serializer = OpenStepSerializer(projectName: projectName, projectFile: self)
            return try serializer.serialize().data(using: .utf8) ?? Data()
        }
        return try super.data(projectName: projectName)
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
