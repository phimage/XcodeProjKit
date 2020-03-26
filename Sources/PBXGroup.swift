//
//  PBXGroup.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXGroup: PBXReference {
    #if LAZY
    public lazy var children: [PBXReference] = self.objects("children")

    public lazy var subGroups: [PBXGroup] = self.children.of(type: PBXGroup.self)
    public lazy var fileRefs: [PBXFileReference] = self.children.of(type: PBXFileReference.self)

    public lazy var usesTabs: Bool? = self.bool("usesTabs")
    #else
    public var children: [PBXReference] { self.objects("children") }

    public var subGroups: [PBXGroup] { self.children.of(type: PBXGroup.self) }
    public var fileRefs: [PBXFileReference] { self.children.of(type: PBXFileReference.self) }

    public var usesTabs: Bool? { self.bool("usesTabs") }
    #endif
}
