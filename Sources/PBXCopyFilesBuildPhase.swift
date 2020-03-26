//
//  PBXCopyFilesBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXCopyFilesBuildPhase: PBXBuildPhase {

    public enum PBXKeys: PBXKey {
        case name
    }

    #if LAZY
    public lazy var name: String? = self.string(PBXKeys.name)
    #else
    public var name: String? { self.string(PBXKeys.name) }
    #endif

    public override var comment: String? {
        return self.name ?? "CopyFiles"
    }

}
