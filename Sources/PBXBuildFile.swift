//
//  PBXBuildFile.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXBuildFile: PBXProjectItem {
    #if LAZY
    public lazy var fileRef: PBXReference? = self.object("fileRef")
    #else
    public var fileRef: PBXReference? { self.object("fileRef") }
    #endif
}
