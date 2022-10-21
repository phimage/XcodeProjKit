//
//  XcodeProj+FilePath.swift
//  XcodeProjKitTests
//
//  Created by Eric Marchand on 02/08/2017.
//  Copyright © 2017 AnOrgaName. All rights reserved.
//

import Foundation

extension XcodeProj {

    static func paths(_ current: PBXGroup, prefix: String) -> [String: PathType] {
        var paths: [String: PathType] = [:]

        for file in current.fileRefs {
            if let path = file.path, let sourceTree = file.sourceTree {
                switch sourceTree {
                case .group:
                    switch sourceTree {
                    case .absolute:
                        paths[file.ref] = .absolute(prefix + "/" + path)

                    case .group:
                        paths[file.ref] = .relativeTo(.sourceRoot, prefix + "/" + path)

                    case .relativeTo(let sourceTreeFolder):
                        paths[file.ref] = .relativeTo(sourceTreeFolder, prefix + "/" + path)
                    }

                case .absolute:
                    paths[file.ref] = .absolute(path)

                case let .relativeTo(sourceTreeFolder):
                    paths[file.ref] = .relativeTo(sourceTreeFolder, path)
                }
            }
        }

        for group in current.subGroups {
            if let path = group.path, let sourceTree = group.sourceTree {
                let str: String

                switch sourceTree {
                case .absolute:
                    str = path

                case .group:
                    str = prefix + "/" + path

                case .relativeTo(.sourceRoot):
                    str = path

                case .relativeTo(.buildProductsDir):
                    str = path

                case .relativeTo(.developerDir):
                    str = path

                case .relativeTo(.sdkRoot):
                    str = path
                }

                paths += self.paths(group, prefix: str)
            } else {
                paths += self.paths(group, prefix: prefix)
            }
        }

        return paths
    }

}
