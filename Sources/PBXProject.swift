//
//  PBXProject.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXProject: PBXContainer, PBXBuildConfigurationListable {
    public lazy var developmentRegion: String? = self.string("developmentRegion")
    public lazy var hasScannedForEncodings: Bool = self.bool("hasScannedForEncodings")
    public lazy var knownRegions: [String] = self.strings("knownRegions")
    public lazy var targets: [PBXNativeTarget] = self.objects("targets")
    public lazy var mainGroup: PBXGroup? = self.object(.mainGroup)
    public lazy var buildConfigurationList: XCConfigurationList? = self.object("buildConfigurationList")

    lazy var targetsByConfigRef: [String: PBXNativeTarget] = {
        var dict: [String: PBXNativeTarget] = [:]
        for target in self.targets {
            if let buildConfigurationList = target.buildConfigurationList {
                dict[buildConfigurationList.ref] = target
            }
        }
        return dict
    }()

}
