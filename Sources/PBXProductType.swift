//
//  PBXProductType.swift
//  XcodeProjKit
//
//  Created by Eric Marchand on 02/08/2017.
//  Copyright © 2017 AnOrgaName. All rights reserved.
//

import Foundation

public enum PBXProductType: String {

    case none = ""

    case application = "com.apple.product-type.application"
    case tool = "com.apple.product-type.tool"

    case kernelExtension = "com.apple.product-type.kernel-extension"
    case kernelExtensionIOKit = "com.apple.product-type.kernel-extension.iokit"

    case libraryStatic = "com.apple.product-type.library.static"
    case libraryDynamic = "com.apple.product-type.library.dynamic"

}
