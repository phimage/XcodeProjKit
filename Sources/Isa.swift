//
// Isa.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public enum Isa: String, CustomStringConvertible {

    case project = "PBXProject"
    case containerItemProxy = "PBXContainerItemProxy"
    case buildFile = "PBXBuildFile"
    case buildStyle = "PBXBuildStyle"
    case aggregateTarget = "PBXAggregateTarget"
    case nativeTarget = "PBXNativeTarget"
    case targetDependency = "PBXTargetDependency"
    case reference = "PBXReference"
    case referenceProxy = "PBXReferenceProxy"
    case fileReference = "PBXFileReference"
    case group = "PBXGroup"
    case variantGroup = "PBXVariantGroup"
    case copyFilesBuildPhase = "PBXCopyFilesBuildPhase"
    case frameworksBuildPhase = "PBXFrameworksBuildPhase"
    case headersBuildPhase = "PBXHeadersBuildPhase"
    case resourcesBuildPhase = "PBXResourcesBuildPhase"
    case shellScriptBuildPhase = "PBXShellScriptBuildPhase"
    case sourcesBuildPhase = "PBXSourcesBuildPhase"
    case versionGroup = "XCVersionGroup"
    case configurationList = "XCConfigurationList"
    case buildConfiguration = "XCBuildConfiguration"

    public var description: String {
        return rawValue
    }
}

extension Isa: Comparable {
    public static func < (lhs: Isa, rhs: Isa) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Isa {

    public var type: PBXObject.Type {
        switch self {
        case .project: return PBXProject.self
        case .containerItemProxy: return PBXContainerItemProxy.self
        case .buildFile: return PBXBuildFile.self
        case .copyFilesBuildPhase: return PBXCopyFilesBuildPhase.self
        case .frameworksBuildPhase: return PBXFrameworksBuildPhase.self
        case .headersBuildPhase: return PBXHeadersBuildPhase.self
        case .resourcesBuildPhase: return PBXResourcesBuildPhase.self
        case .shellScriptBuildPhase: return PBXShellScriptBuildPhase.self
        case .sourcesBuildPhase: return PBXSourcesBuildPhase.self
        case .buildStyle: return PBXBuildStyle.self
        case .aggregateTarget: return PBXAggregateTarget.self
        case .nativeTarget: return PBXNativeTarget.self
        case .targetDependency: return PBXTargetDependency.self
        case .reference: return PBXReference.self
        case .referenceProxy: return PBXReferenceProxy.self
        case .fileReference: return PBXFileReference.self
        case .group: return PBXGroup.self
        case .variantGroup: return PBXVariantGroup.self
        case .versionGroup: return XCVersionGroup.self
        case .configurationList: return XCConfigurationList.self
        case .buildConfiguration: return XCBuildConfiguration.self
        }
    }
}
