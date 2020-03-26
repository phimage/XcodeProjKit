//
//  XCConfigurationList.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class XCConfigurationList: PBXProjectItem {

    #if LAZY
    public lazy var buildConfigurations: [XCBuildConfiguration] = self.objects("buildConfigurations")
    #else
    public var buildConfigurations: [XCBuildConfiguration] { self.objects("buildConfigurations") }
    #endif

}

public protocol PBXBuildConfigurationListable {
     var buildConfigurationList: XCConfigurationList? {get}
}
