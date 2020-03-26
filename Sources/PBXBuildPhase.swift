//
//  PBXBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public /* abstract */ class PBXBuildPhase: PBXProjectItem {

    public enum PBXKeys: PBXKey {
        case files
    }

    #if LAZY
    public lazy var files: [PBXBuildFile] = self.objects(PBXKeys.files)
    #else
    public var files: [PBXBuildFile] { self.objects(PBXKeys.files) }
    #endif
}
