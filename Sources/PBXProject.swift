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
    }

    #if LAZY
    public lazy var developmentRegion: String? = self.string(PBXKeys.developmentRegion)
    public lazy var hasScannedForEncodings: Bool = self.bool(PBXKeys.hasScannedForEncodings)
    public lazy var knownRegions: [String] = self.strings(PBXKeys.knownRegions)
    public lazy var targets: [PBXNativeTarget] = self.objects(PBXKeys.targets)
    public lazy var mainGroup: PBXGroup? = self.object(.mainGroup)
    public lazy var buildConfigurationList: XCConfigurationList? = self.object(PBXKeys.buildConfigurationList)

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
