//
//  PBXProject.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXProject: PBXContainer, PBXBuildConfigurationListable {

    public enum PBXKeys: PBXKey {
        case developmentRegion
        case hasScannedForEncodings
        case knownRegions
        case targets
        case mainGroup
        case buildConfigurationList
        case packageReferences
    }

    #if LAZY
    public lazy var developmentRegion: String? = self.string(PBXKeys.developmentRegion)
    public lazy var hasScannedForEncodings: Bool = self.bool(PBXKeys.hasScannedForEncodings)
    public lazy var knownRegions: [String] = self.strings(PBXKeys.knownRegions)
    public lazy var targets: [PBXNativeTarget] = self.objects(PBXKeys.targets)
    public lazy var mainGroup: PBXGroup? = self.object(.mainGroup)
    public lazy var buildConfigurationList: XCConfigurationList? = self.object(PBXKeys.buildConfigurationList)
    public lazy var packageReferences: [XCRemoteSwiftPackageReference] = self.objects(PBXKeys.packageReferences)

    lazy var targetsByConfigRef: [String: PBXNativeTarget] = {
        var dict: [String: PBXNativeTarget] = [:]
        for target in self.targets {
            if let buildConfigurationList = target.buildConfigurationList {
                dict[buildConfigurationList.ref] = target
            }
        }
        return dict
    }()
    #else
    public var developmentRegion: String? { self.string(PBXKeys.developmentRegion) }
    public var hasScannedForEncodings: Bool { self.bool(PBXKeys.hasScannedForEncodings) }
    public var knownRegions: [String] { self.strings(PBXKeys.knownRegions) }
    public var targets: [PBXNativeTarget] { self.objects(PBXKeys.targets) }
    public var mainGroup: PBXGroup? { self.object(PBXKeys.mainGroup) }
    public var buildConfigurationList: XCConfigurationList? { self.object(PBXKeys.buildConfigurationList) }
    public var packageReferences: [XCRemoteSwiftPackageReference] { self.objects(PBXKeys.packageReferences) }

    var targetsByConfigRef: [String: PBXNativeTarget] {
        var dict: [String: PBXNativeTarget] = [:]
        for target in self.targets {
            if let buildConfigurationList = target.buildConfigurationList {
                dict[buildConfigurationList.ref] = target
            }
        }
        return dict
    }
    #endif

}

extension PBXProject {

    public enum Attribute: String {
        case lastSwiftUpdateCheck = "LastSwiftUpdateCheck"
        case lastUpgradeCheck = "LastUpgradeCheck"
        case organizationName = "ORGANIZATIONNAME"
        case targetAttributes = "TargetAttributes"
    }

    public var attributes: [String: Any]? {
        get {
            return self.fields["attributes"] as? [String: Any]
        }
        set {
            self.fields["attributes"] = newValue
        }
    }

    public func attribute(_ key: Attribute) -> Any? {
        return self.attributes?[key.rawValue]
    }

    public func set(value: Any, into key: Attribute) {
        self.attributes?[key.rawValue] = value
    }

    public struct Version: Comparable, CustomStringConvertible {

        public var major: Int
        public var minor: Int

        public init?(_ string: String?) {
            guard let string = string, string.count > 3 else {
                return nil
            }
            let majorString = String(string.prefix(2))
            let minorString = String(string.suffix(string.count - 2))
            guard let major = Int(majorString), let minor = Int(minorString) else {
                return nil
            }
            self.major = major
            self.minor = minor
        }

        public init(major: Int, minor: Int) {
            self.major = major
            self.minor = minor
        }

        public static func < (lhs: PBXProject.Version, rhs: PBXProject.Version) -> Bool {
            if lhs.major < rhs.major {
                return true
            }
            if lhs.major > rhs.major {
                return false
            }
            return lhs.minor < rhs.minor
        }

        public static func == (lhs: PBXProject.Version, rhs: PBXProject.Version) -> Bool {
            return lhs.major == rhs.major && lhs.minor == rhs.minor
        }

        public var description: String {
            return "\(self.major).\(self.minor)" // XXX padding on major or not?
        }

        public var openStep: String {
            return "\(String(format: "%02d", self.major))\(String(format: "%02d", self.minor))"
        }
    }

    public var lastUpgradeCheck: Version? {
        get {
            return Version(attribute(.lastUpgradeCheck) as? String)
        }
        set {
            if let version = newValue?.openStep {
                set(value: version, into: .lastUpgradeCheck)
            }
        }
    }

    public var lastSwiftUpdateCheck: Version? {
        get {
            return Version(attribute(.lastSwiftUpdateCheck) as? String)
        }
        set {
            if let version = newValue?.openStep {
                set(value: version, into: .lastSwiftUpdateCheck)
            }
        }
    }

    public var organizationName: String? {
        get {
            return attribute(.organizationName) as? String
        }
        set {
            if let newValue = newValue {
                set(value: newValue, into: .organizationName)
            }// XXX unset?
        }
    }
}
