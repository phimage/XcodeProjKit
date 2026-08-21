//
//  XCLocalSwiftPackageReference.swift
//  XcodeProjKit
//
//  Created by phimage on 21/08/2026.
//  Copyright © 2026 phimage (Eric Marchand). All rights reserved.
//

import Foundation

/// A reference to a Swift package located on disk (relative to the project), introduced in Xcode 15.
public class XCLocalSwiftPackageReference: PBXObject {

    public enum PBXKeys: PBXKey {
        case relativePath
    }

    #if LAZY
    public lazy var relativePath: String? = self.string(PBXKeys.relativePath)
    #else
    public var relativePath: String? { self.string(PBXKeys.relativePath) }
    #endif

    public override var comment: String? {
        guard let relativePath = self.relativePath else {
            return super.comment
        }
        let name = (relativePath as NSString).lastPathComponent
        return "XCLocalSwiftPackageReference \"\(name)\""
    }
}
