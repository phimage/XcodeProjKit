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
        testParse("ok/advance.56412ec.project")
    }
    
    func testafnetworking() {
        testParse("ok/afnetworking.c8e5ce2.project")
    }
    
    func testcharts() {
        testParse("ok/charts.8eaba34.project")
    }
        
    func testcriollo() {
        testParse("ok/criollo.b1e014c.project")
    }
        
    func testdwifft() {
        testParse("ok/dwifft.05d449a.project")
    }
        
    func testdznemptydataset() {
        testParse("ok/dznemptydataset.d3ab4e0.project")
    }
        
    func testinjectionpluginlite() {
        testParse("ok/injectionpluginlite.f6d6387.project")
    }
        
    func testmasonry() {
        testParse("ok/masonry.b88578c.project")
    }
        
    func testmjrefreshexample() {
        testParse("ok/mjrefreshexample.3b41316.project")
    }
        
    func testpeekpop() {
        testParse("ok/peekpop.c27c05e.project")
    }
        
    func testreactivecocoa() {
        testParse("ok/reactivecocoa.4384610.project")
    }
        
    func testsdwebimage() {
        testParse("ok/sdwebimage.07fe1f0.project")
    }
        
    func testsptpersistencache() {
        testParse("ok/sptpersistencache.cfbe4f8.project")
    }
        
    func testsqlitemigrationmanager() {
        testParse("ok/sqlitemigrationmanager.742ac46.project")
    }
        
    func testv2exswift() {
        testParse("ok/v2exswift.53049f1.project")
    }
        
    func testweixin() {
        testParse("ok/weixin.17aeced.project")
    }
        
    func testxcglogger() {
        testParse("ok/xcglogger.iosdemo.5510795.project")
    }
        
    func testyocelsius() {
        testParse("ok/yocelsius.09b4cb7.project")
    }

    func testoauthswift() {
        testParse("ok/oauthswift.project")
    }

    func testplist() {
        testParse("ok/plist")
    }

    func testjson() {
        testParse("ok/json")
    }

    func testswiftpm() {
        let proj = testParse("ok/swiftpm.project")
        XCTAssertNotNil(proj?.objects.object("48A408192662576D0068A35B"))
        XCTAssertNotNil(proj?.objects.object("48A4081A2662576D0068A35B"))
    }

    @discardableResult
    func testParse(_ resource: String) -> XcodeProj? {
        if let url = url(forResource: resource, withExtension: XcodeProj.pbxprojFileExtension) {
            do {
                let proj = try XcodeProj(url: url)
                XCTAssertNotNil(proj.project.mainGroup)
                XCTAssertNotNil(proj.project.buildConfigurationList)
                return proj
            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("Missing resource \(resource)")
        }
        return nil
    }

}
