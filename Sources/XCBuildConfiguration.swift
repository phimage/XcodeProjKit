//
//  XCBuildConfiguration.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class XCBuildConfiguration: PBXBuildStyle {

    public enum PBXKeys: PBXKey {
        case name
        case baseConfigurationReference
    }

    #if LAZY
    public lazy var name: String? = self.string(PBXKeys.name)
    public var baseConfigurationReference: PBXFileReference? = self.object(PBXKeys.baseConfigurationReference)
    #else
    public var name: String? { self.string(PBXKeys.name) }
    public var baseConfigurationReference: PBXFileReference? { self.object(PBXKeys.baseConfigurationReference) }
    #endif

    public override var comment: String? {
        return self.name ?? "CopyFiles"
    }

}
