//
//  PBXShellScriptBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXShellScriptBuildPhase: PBXBuildPhase {
    #if LAZY
    public lazy var name: String? = self.string("name")
    public lazy var shellScript: String? = self.string("shellScript")
    public lazy var inputPaths: [String] = self.strings("inputPaths")
    public lazy var outputPaths: [String] = self.strings("outputPaths")
    #else
    public var name: String? { self.string("name") }
    public var shellScript: String? { self.string("shellScript") }
    public var inputPaths: [String] { self.strings("inputPaths") }
    public var outputPaths: [String] { self.strings("outputPaths") }
    #endif

    public override var comment: String? {
        return self.name ?? "ShellScript"
    }

}
