//
//  PBXBuildStyle.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXBuildStyle: PBXProjectItem {

    #if LAZY
    public lazy var buildSettings: [String: Any]? = dictionary("buildSettings")
    #else
    public var buildSettings: [String: Any]? { dictionary("buildSettings") }
    #endif

}
