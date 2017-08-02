//
//  SourceTree.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public enum SourceTree {
    case absolute
    case group
    case relativeTo(SourceTreeFolder)

    public init?(sourceTreeString: String) {
        switch sourceTreeString {
        case "<absolute>":
            self = .absolute

        case "<group>":
            self = .group

        default:
            guard let sourceTreeFolder = SourceTreeFolder(rawValue: sourceTreeString) else {
                return nil
            }
            self = .relativeTo(sourceTreeFolder)
        }
    }
}
