//
//  XcodeProjKitWriteTests.swift
//  XcodeProjKitTests
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import XCTest
@testable import XcodeProjKit

class XcodeProjKitWriteTests: XCTestCase {
    
    let bundle = Bundle(for: XcodeProjKitWriteTests.self)
    static let directory = NSTemporaryDirectory()+"xcodeproj/"
    
    static override func setUp() {
        do {
           try FileManager.default.createDirectory(atPath: XcodeProjKitWriteTests.directory, withIntermediateDirectories: true)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testAdvance() {
        testWrite("ok/advance.56412ec.project")
    }
    
    func testafnetworking() {
        testWrite("ok/afnetworking.c8e5ce2.project")
    }
    
    func testcharts() {
        testWrite("ok/charts.8eaba34.project")
    }
    
    func testcriollo() {
        testWrite("ok/criollo.b1e014c.project")
    }
    
    func testdwifft() {
        testWrite("ok/dwifft.05d449a.project")
    }
    
    func testdznemptydataset() {
        testWrite("ok/dznemptydataset.d3ab4e0.project")
    }
    
    func testinjectionpluginlite() {
        testWrite("ok/injectionpluginlite.f6d6387.project")
    }
    
    func testmasonry() {
        testWrite("ok/masonry.b88578c.project")
    }
    
    func testmjrefreshexample() {
        testWrite("ok/mjrefreshexample.3b41316.project")
    }
    
    func testpeekpop() {
        testWrite("ok/peekpop.c27c05e.project")
    }
    
    func testreactivecocoa() {
        testWrite("ok/reactivecocoa.4384610.project")
    }
    
    func testsdwebimage() {
        testWrite("ok/sdwebimage.07fe1f0.project")
    }
    
    func testsptpersistencache() {
        testWrite("ok/sptpersistencache.cfbe4f8.project")
    }
    
    func testsqlitemigrationmanager() {
        testWrite("ok/sqlitemigrationmanager.742ac46.project")
    }
    
    func testv2exswift() {
        testWrite("ok/v2exswift.53049f1.project")
    }
    
    func testweixin() {
        testWrite("ok/weixin.17aeced.project")
    }
    
    func testxcglogger() {
        testWrite("ok/xcglogger.iosdemo.5510795.project")
    }
    
    func testyocelsius() {
        testWrite("ok/yocelsius.09b4cb7.project")
    }
    
    func testWrite(_ resource: String) {
        if let url = url(forResource: resource, withExtension: XcodeProj.pbxprojFileExtension) {
            do {
                let proj = try XcodeProj(url: url)
                XCTAssertNotNil(proj.project.mainGroup)
                XCTAssertNotNil(proj.project.buildConfigurationList)
                let testURL = URL(fileURLWithPath: XcodeProjKitWriteTests.directory + resource.replacingOccurrences(of: "ok/", with: "") + "." + XcodeProj.pbxprojFileExtension)
                try proj.write(to: testURL)

                assertContentsEqual(url, testURL)

                // test passing by xml before recoding to openstep
                let testURLPlist = URL(fileURLWithPath: XcodeProjKitWriteTests.directory + resource.replacingOccurrences(of: "ok/", with: "") + ".plist")
                try proj.write(to: testURLPlist, format: .xml)
                try XcodeProj(url: testURLPlist).write(to: testURLPlist.appendingPathExtension("pbxproj"), format: .openStep, projectName: proj.projectName, lineEnding: proj.lineEnding)
                print("\(url.path)")
                print("\(testURLPlist.appendingPathExtension("pbxproj").path)")
                assertContentsEqual(url, testURLPlist.appendingPathExtension("pbxproj"))

                // test passing by json before recoding to openstep
                let testURLJSON = URL(fileURLWithPath: XcodeProjKitWriteTests.directory + resource.replacingOccurrences(of: "ok/", with: "") + ".json")
                try proj.write(to: testURLJSON, format: .json)
                try XcodeProj(url: testURLJSON).write(to: testURLJSON.appendingPathExtension(".pbxproj"), format: .openStep, projectName: proj.projectName, lineEnding: proj.lineEnding)
                assertContentsEqual(url, testURLJSON.appendingPathExtension(".pbxproj"))
            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("Missing resource \(resource)")
        }
    }

}




