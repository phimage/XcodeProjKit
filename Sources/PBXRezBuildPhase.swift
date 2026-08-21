//
//  PBXRezBuildPhase.swift
//  XcodeProjKit
//
//  Created by phimage on 21/08/2026.
//  Copyright © 2026 phimage (Eric Marchand). All rights reserved.
//

import Foundation

/// The legacy "Build Carbon Resources" (.r files) build phase.
public class PBXRezBuildPhase: PBXBuildPhase {

    public override var comment: String? {
        return "Rez"
    }

}
