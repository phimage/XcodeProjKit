//
//  PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet.swift
//  XcodeProjKit
//
//  Created by phimage on 21/08/2026.
//  Copyright © 2026 phimage (Eric Marchand). All rights reserved.
//

import Foundation

/// Overrides which files of a `PBXFileSystemSynchronizedRootGroup` belong to a given build phase
/// (e.g. exclude some synchronized files from the resources or sources phase). Xcode 16+.
public class PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet: PBXObject {

    public enum PBXKeys: PBXKey {
        case buildPhase
        case membershipExceptions
        case attributesByRelativePath
    }

    #if LAZY
    public lazy var buildPhase: PBXBuildPhase? = self.object(PBXKeys.buildPhase)
    public lazy var membershipExceptions: [String] = self.strings(PBXKeys.membershipExceptions)
    #else
    /// The build phase these exceptions apply to.
    public var buildPhase: PBXBuildPhase? { self.object(PBXKeys.buildPhase) }
    /// Relative paths excluded from the build phase membership.
    public var membershipExceptions: [String] { self.strings(PBXKeys.membershipExceptions) }
    #endif
}
