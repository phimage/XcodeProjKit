//
//  PBXFileSystemSynchronizedRootGroup.swift
//  XcodeProjKit
//
//  Created by phimage on 21/08/2026.
//  Copyright © 2026 phimage (Eric Marchand). All rights reserved.
//

import Foundation

/// A folder whose content is synchronized with the file system, introduced in Xcode 16.
/// Instead of listing every child as a `PBXFileReference`/`PBXGroup`, Xcode references the folder
/// once and keeps its membership in sync automatically.
public class PBXFileSystemSynchronizedRootGroup: PBXReference {

    public enum PBXKeys: PBXKey {
        case explicitFileTypes
        case explicitFolders
        case exceptions
    }

    #if LAZY
    public lazy var explicitFileTypes: [String: String]? = self.dictionary(PBXKeys.explicitFileTypes)
    public lazy var explicitFolders: [String] = self.strings(PBXKeys.explicitFolders)
    public lazy var exceptions: [PBXObject] = self.objects(PBXKeys.exceptions)
    #else
    /// Maps relative paths inside the synchronized folder to an explicit file type.
    public var explicitFileTypes: [String: String]? { self.dictionary(PBXKeys.explicitFileTypes) }
    /// Relative paths to child folders whose configuration is overridden.
    public var explicitFolders: [String] { self.strings(PBXKeys.explicitFolders) }
    /// Exception sets overriding the membership/attributes of some synchronized children.
    public var exceptions: [PBXObject] { self.objects(PBXKeys.exceptions) }
    #endif
}
