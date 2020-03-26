//
//  PBXFileReference.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXFileReference: PBXReference {

    public enum PBXKeys: PBXKey {
        case lastKnownFileType
        case explicitFileType
    }

    #if LAZY
    public lazy var lastKnownFileType: String? = self.string(PBXKeys.lastKnownFileType)
    public lazy var explicitFileType: String? = self.string(PBXKeys.explicitFileType)
    #else
    public var lastKnownFileType: String? { self.string(PBXKeys.lastKnownFileType) }
    public var explicitFileType: String? { self.string(PBXKeys.explicitFileType) }
    #endif

    public func fullPath(_ project: XcodeProj) -> PathType? {
       return project.objects.fullFilePaths[self.ref]
    }

}
