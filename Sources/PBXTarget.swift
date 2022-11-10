//
//  PBXTarget.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public /* abstract */ class PBXTarget: PBXProjectItem, PBXBuildConfigurationListable {

    public enum PBXKeys: PBXKey {
        case name
        case productName
        case buildPhases
        case buildRules
        case buildConfigurationList
        case dependencies
        case packageProductDependencies
    }

    #if LAZY
    public lazy var name: String = self.string(PBXKeys.name)
    public lazy var productName: String? = self.string(PBXKeys.productName)
    public lazy var buildPhases: [PBXBuildPhase] = self.objects(PBXKeys.buildPhases)
    public lazy var buildRules: [PBXBuildRule] = self.objects(PBXKeys.buildRules)
    public lazy var buildConfigurationList: XCConfigurationList? = self.object(PBXKeys.buildConfigurationList)
    public lazy var dependencies: [PBXTargetDependency] = self.objects(PBXKeys.dependencies)
    public lazy var packageProductDependencies: [XCSwiftPackageProductDependency] = self.objects(PBXKeys.packageProductDependencies) // swiftlint:disable:this line_length
    #else
    public var name: String { self.string(PBXKeys.name) }
    public var productName: String? { self.string(PBXKeys.productName) }
    public var buildPhases: [PBXBuildPhase] { self.objects(PBXKeys.buildPhases) }
    public var buildRules: [PBXBuildRule] { self.objects(PBXKeys.buildRules) }
    public var buildConfigurationList: XCConfigurationList? { self.object(PBXKeys.buildConfigurationList) }
    public var dependencies: [PBXTargetDependency] { self.objects(PBXKeys.dependencies) }
    public var packageProductDependencies: [XCSwiftPackageProductDependency] {self.objects(PBXKeys.packageProductDependencies) } // swiftlint:disable:this line_length
    #endif

    public override var comment: String? {
        return self.name
    }

}
