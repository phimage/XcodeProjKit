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
                
                let testURLPlist = URL(fileURLWithPath: XcodeProjKitWriteTests.directory + resource.replacingOccurrences(of: "ok/", with: "") + ".plist")
                try proj.write(to: testURLPlist, format: .xml)
                
                compare(url, testURL)
                
            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("Missing resource \(resource)")
        }
    }

    func compare(_ url: URL, _ testURL: URL ) {
        do {
            let contents = try String(contentsOf: url)
            let testContents = try String(contentsOf: testURL)
            #if os(Linux)
            XCTAssertEqual(contents.replacingOccurrences(matchingPattern: "classes = \\{\\s*\\};", by: "classes = [:];"), testContents, "diff \(url.path) \(testURL.path)")
            #else
            XCTAssertEqual(contents, testContents)
            #endif
            
        } catch {
            XCTFail("\(error)")
        }
        
    }
    
}

fileprivate extension String {
    func replacingOccurrences(matchingPattern pattern: String, by replacement: String) -> String {
        do {
            let expression = try NSRegularExpression(pattern: pattern, options: [])
            let matches = expression.matches(in: self, options: [], range: NSRange(startIndex..<endIndex, in: self))
            return matches.reversed().reduce(into: self) { (current, result) in
                let range = Range(result.range, in: current)!
                current.replaceSubrange(range, with: replacement)
            }
        } catch {
            return self
        }
    }
}
