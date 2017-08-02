//
//  XcodeProjKitTests.swift
//  XcodeProjKitTests
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import XCTest
@testable import XcodeProjKit

class XcodeProjKitParseTests: XCTestCase {
    let bundle = Bundle(for: XcodeProjKitParseTests.self)
    
    func testAdvance() {
        testParse("advance.56412ec.project")
    }
    
    func testafnetworking() {
        testParse("afnetworking.c8e5ce2.project")
    }
    
    func testcharts() {
        testParse("charts.8eaba34.project")
    }
        
    func testcriollo() {
        testParse("criollo.b1e014c.project")
    }
        
    func testdwifft() {
        testParse("dwifft.05d449a.project")
    }
        
    func testdznemptydataset() {
        testParse("dznemptydataset.d3ab4e0.project")
    }
        
    func testinjectionpluginlite() {
        testParse("injectionpluginlite.f6d6387.project")
    }
        
    func testmasonry() {
        testParse("masonry.b88578c.project")
    }
        
    func testmjrefreshexample() {
        testParse("mjrefreshexample.3b41316.project")
    }
        
    func testpeekpop() {
        testParse("peekpop.c27c05e.project")
    }
        
    func testreactivecocoa() {
        testParse("reactivecocoa.4384610.project")
    }
        
    func testsdwebimage() {
        testParse("sdwebimage.07fe1f0.project")
    }
        
    func testsptpersistencache() {
        testParse("sptpersistencache.cfbe4f8.project")
    }
        
    func testsqlitemigrationmanager() {
        testParse("sqlitemigrationmanager.742ac46.project")
    }
        
    func testv2exswift() {
        testParse("v2exswift.53049f1.project")
    }
        
    func testweixin() {
        testParse("weixin.17aeced.project")
    }
        
    func testxcglogger() {
        testParse("xcglogger.iosdemo.5510795.project")
    }
        
    func testyocelsius() {
        testParse("yocelsius.09b4cb7.project")
    }

    func testParse(_ resource: String) {
        if let url = bundle.url(forResource: resource, withExtension: XcodeProj.pbxprojFileExtension) {
            do {
                let proj = try XcodeProj(url: url)
                XCTAssertNotNil(proj.project.mainGroup)
                XCTAssertNotNil(proj.project.buildConfigurationList)
            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("Missing resource \(resource)")
        }
    }
    
}
