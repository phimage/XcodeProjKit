//
//  PBXReferenceProxy.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

public class PBXReferenceProxy: PBXReference {

    #if LAZY
    public lazy var remoteRef: PBXContainerItemProxy? = self.object("remoteRef")
    #else
    public var remoteRef: PBXContainerItemProxy? { self.object("remoteRef") }
    #endif

}
