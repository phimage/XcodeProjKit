//
//  XCConfigurationList.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class XCConfigurationList: PBXProjectItem {}

public protocol PBXBuildConfigurationListable {
     var buildConfigurationList: XCConfigurationList? {get}
}
