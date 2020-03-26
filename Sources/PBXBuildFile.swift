//
//  PBXBuildFile.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXBuildFile: PBXProjectItem {

    public enum PBXKeys: PBXKey {
        case fileRef
        case settings
    }

    #if LAZY
    public lazy var fileRef: PBXReference? = self.object(PBXKeys.fileRef)
    public lazy var settings: [String: Any]? = self.dictionary(PBXKeys.settings)
    #else
    public var fileRef: PBXReference? { self.object(PBXKeys.fileRef) }
    public var settings: [String: Any]? { self.dictionary(PBXKeys.settings) }
    #endif

}
