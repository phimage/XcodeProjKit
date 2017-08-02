//
//  Path.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public enum Path {
    case absolute(String)
    case relativeTo(SourceTreeFolder, String)
}

extension Path {

    public func url(with urlForSourceTreeFolder: (SourceTreeFolder) -> URL) -> URL {
        switch self {
        case let .absolute(absolutePath):
            return URL(fileURLWithPath: absolutePath).standardizedFileURL

        case let .relativeTo(sourceTreeFolder, relativePath):
            let sourceTreeURL = urlForSourceTreeFolder(sourceTreeFolder)
            return sourceTreeURL.appendingPathComponent(relativePath).standardizedFileURL
        }
    }

}
