//
//  PBXShellScriptBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXShellScriptBuildPhase: PBXBuildPhase {
    public lazy var name: String? = self.string("name")
    public lazy var shellScript: String? = self.string("shellScript")

    public override var comment: String? {
        return self.name ?? "ShellScript"
    }

}
