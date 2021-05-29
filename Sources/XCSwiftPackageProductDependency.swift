//
//  XCSwiftPackageProductDependency.swift
//  XcodeProjKit
//
//  Created by emarchand on 29/05/2021.
//  Copyright © 2021 AnOrgaName. All rights reserved.
//

import Foundation

public class XCSwiftPackageProductDependency: PBXObject {

    public enum PBXKeys: PBXKey {
        case productName
        case package
    }

    #if LAZY
    public lazy var productName: String? = self.string(PBXKeys.productName)
    public lazy var package: XCRemoteSwiftPackageReference? = self.object(PBXKeys.productName)
    #else
    public var productName: String? { self.string(PBXKeys.productName) } // but not ""
    public var package: XCRemoteSwiftPackageReference? { self.object(PBXKeys.productName) }
    #endif

}
