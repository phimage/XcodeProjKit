//
//  PBXBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public /* abstract */ class PBXBuildPhase: PBXProjectItem {
    #if LAZY
    public lazy var files: [PBXBuildFile] = self.objects("files")
    #else
    public var files: [PBXBuildFile] { self.objects("files") }
    #endif
}
