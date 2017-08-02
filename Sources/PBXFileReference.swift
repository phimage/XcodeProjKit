//
//  PBXFileReference.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXFileReference: PBXReference {

    public func fullPath(_ project: XcodeProj) -> Path? {
       return project.objects.fullFilePaths[self.ref]
    }

}
