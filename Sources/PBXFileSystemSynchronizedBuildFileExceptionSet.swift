//
//  PBXFileSystemSynchronizedBuildFileExceptionSet.swift
//  XcodeProjKit
//
//  Created by phimage on 21/08/2026.
//  Copyright © 2026 phimage (Eric Marchand). All rights reserved.
//

import Foundation

/// Overrides, for one target, how some files of a `PBXFileSystemSynchronizedRootGroup` are built
/// (files to exclude from membership, header visibility, per-file compiler flags…). Xcode 16+.
public class PBXFileSystemSynchronizedBuildFileExceptionSet: PBXObject {

    public enum PBXKeys: PBXKey {
        case target
        case membershipExceptions
        case publicHeaders
        case privateHeaders
        case attributesByRelativePath
        case platformFiltersByRelativePath
    }

    // Note: `additionalCompilerFlagsByRelativePath`, `attributesByRelativePath` and
    // `platformFiltersByRelativePath` are preserved via the raw `fields` (they round-trip)
    // even though they are not exposed as typed accessors here.

    #if LAZY
    public lazy var target: PBXTarget? = self.object(PBXKeys.target)
    public lazy var membershipExceptions: [String] = self.strings(PBXKeys.membershipExceptions)
    public lazy var publicHeaders: [String] = self.strings(PBXKeys.publicHeaders)
    public lazy var privateHeaders: [String] = self.strings(PBXKeys.privateHeaders)
    #else
    /// The target these exceptions apply to.
    public var target: PBXTarget? { self.object(PBXKeys.target) }
    /// Relative paths excluded from the target membership.
    public var membershipExceptions: [String] { self.strings(PBXKeys.membershipExceptions) }
    /// Relative paths exposed as public headers.
    public var publicHeaders: [String] { self.strings(PBXKeys.publicHeaders) }
    /// Relative paths exposed as private headers.
    public var privateHeaders: [String] { self.strings(PBXKeys.privateHeaders) }
    #endif
}
