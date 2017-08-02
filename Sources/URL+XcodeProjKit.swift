//
//  URL+XcodeProjKit.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

extension URL {

    var isDirectoryURL: Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory)
            && isDirectory.boolValue
    }

}
