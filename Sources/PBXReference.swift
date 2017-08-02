//
//  PBXReference.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXReference: PBXContainerItem {

    public lazy var name: String? = self.string("name")
    public lazy var path: String? = self.string("path")
    public lazy var sourceTree: SourceTree? = SourceTree(sourceTreeString: self.string("sourceTree") ?? "")

    public override var comment: String? {
        return self.name ?? self.path
    }

}
