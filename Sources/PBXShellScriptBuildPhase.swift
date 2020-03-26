//
//  PBXShellScriptBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXShellScriptBuildPhase: PBXBuildPhase {

    public enum PBXKeys: PBXKey {
        case name
        case shellScript
        case inputPaths
        case outputPaths
    }

    #if LAZY
    public lazy var name: String? = self.string(PBXKeys.name)
    public lazy var shellScript: String? = self.string(PBXKeys.shellScript)
    public lazy var inputPaths: [String] = self.strings(PBXKeys.inputPaths)
    public lazy var outputPaths: [String] = self.strings(PBXKeys.outputPaths)
    #else
    public var name: String? { self.string(PBXKeys.name) }
    public var shellScript: String? { self.string(PBXKeys.shellScript) }
    public var inputPaths: [String] { self.strings(PBXKeys.inputPaths) }
    public var outputPaths: [String] { self.strings(PBXKeys.outputPaths) }
    #endif

    public override var comment: String? {
        return self.name ?? "ShellScript"
    }

}
