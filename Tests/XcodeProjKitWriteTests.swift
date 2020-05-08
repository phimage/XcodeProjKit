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
        testWrite("advance.56412ec.project")
    }
    
    func testafnetworking() {
        testWrite("afnetworking.c8e5ce2.project")
    }
    
    func testcharts() {
        testWrite("charts.8eaba34.project")
    }
    
    func testcriollo() {
        testWrite("criollo.b1e014c.project")
    }
    
    func testdwifft() {
        testWrite("dwifft.05d449a.project")
    }
    
    func testdznemptydataset() {
        testWrite("dznemptydataset.d3ab4e0.project")
    }
    
    func testinjectionpluginlite() {
        testWrite("injectionpluginlite.f6d6387.project")
    }
    
    func testmasonry() {
        testWrite("masonry.b88578c.project")
    }
    
    func testmjrefreshexample() {
        testWrite("mjrefreshexample.3b41316.project")
    }
    
    func testpeekpop() {
        testWrite("peekpop.c27c05e.project")
    }
    
    func testreactivecocoa() {
        testWrite("reactivecocoa.4384610.project")
    }
    
    func testsdwebimage() {
        testWrite("sdwebimage.07fe1f0.project")
    }
    
    func testsptpersistencache() {
        testWrite("sptpersistencache.cfbe4f8.project")
    }
    
    func testsqlitemigrationmanager() {
        testWrite("sqlitemigrationmanager.742ac46.project")
    }
    
    func testv2exswift() {
        testWrite("v2exswift.53049f1.project")
    }
    
    func testweixin() {
        testWrite("weixin.17aeced.project")
    }
    
    func testxcglogger() {
        testWrite("xcglogger.iosdemo.5510795.project")
    }
    
    func testyocelsius() {
        testWrite("yocelsius.09b4cb7.project")
    }
    
    func testWrite(_ resource: String) {
        if let url = url(forResource: resource, withExtension: XcodeProj.pbxprojFileExtension) {
            do {
                let proj = try XcodeProj(url: url)
                XCTAssertNotNil(proj.project.mainGroup)
                XCTAssertNotNil(proj.project.buildConfigurationList)
                let testURL = URL(fileURLWithPath: XcodeProjKitWriteTests.directory + resource + "." + XcodeProj.pbxprojFileExtension)
                try proj.write(to: testURL)
                
                let testURLPlist = URL(fileURLWithPath: XcodeProjKitWriteTests.directory + resource + ".plist")
                try proj.write(to: testURLPlist, format: .xml)
                
                compare(url, testURL)
                
            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("Missing resource \(resource)")
        }
    }

    func url(forResource resource: String, withExtension ext: String) -> URL? {
        #if !os(Linux)
        if let url = bundle.url(forResource: resource, withExtension: ext) {
            return url
        }
        #endif
        let url = URL(fileURLWithPath: "Tests/ok/\(resource).\(ext)")
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        }
        return nil
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
    func replacingOccurrences(matchingPattern pattern: String, replacementProvider: (String) -> String?) -> String {
        let expression = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = expression.matches(in: self, options: [], range: NSRange(startIndex..<endIndex, in: self))
        return matches.reversed().reduce(into: self) { (current, result) in
            let range = Range(result.range, in: current)!
            let token = String(current[range])
            guard let replacement = replacementProvider(token) else { return }
            current.replaceSubrange(range, with: replacement)
        }
    }
}
