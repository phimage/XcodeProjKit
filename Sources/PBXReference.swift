//
//  PBXReference.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXReference: PBXContainerItem {

    public enum PBXKeys: PBXKey {
        case name
        case path
        case sourceTree
    }

    #if LAZY
    public lazy var name: String? = self.string(PBXKeys.name)
    public lazy var path: String? = self.string(PBXKeys.path)
    public lazy var sourceTree: SourceTree? = SourceTree(sourceTreeString: self.string(PBXKeys.sourceTree) ?? "")
    #else
    public var name: String? { self.string(PBXKeys.name) }
    public var path: String? { self.string(PBXKeys.path) }
    public var sourceTree: SourceTree? { SourceTree(sourceTreeString: self.string(PBXKeys.sourceTree) ?? "") }
    #endif

    public override var comment: String? {
        return self.name ?? self.path
    }

}
