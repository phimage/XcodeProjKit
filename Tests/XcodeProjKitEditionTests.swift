//
//  File.swift
//  
//
//  Created by phimage on 25/10/2020.
//

import Foundation
import XCTest
@testable import XcodeProjKit

class XcodeProjKitEditionTests: XCTestCase {

    static let directory = NSTemporaryDirectory()+"xcodeproj/"

    static override func setUp() {
        do {
           try FileManager.default.createDirectory(atPath: XcodeProjKitEditionTests.directory, withIntermediateDirectories: true)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEdit() {
        testParse("ok/afnetworking.c8e5ce2.project")
    }

    func testParse(_ resource: String) {
        if let url = url(forResource: resource, withExtension: XcodeProj.pbxprojFileExtension) {
            do {
                let proj = try XcodeProj(url: url)
                let project = proj.project

                XCTAssertNotNil(project.attributes)

                XCTAssertNotNil(project.attribute(.lastUpgradeCheck))
                let version = project.lastUpgradeCheck
                XCTAssertNotNil(project.lastUpgradeCheck)

                project.set(value: "1200", into: .lastUpgradeCheck)
                XCTAssertNotNil(project.lastUpgradeCheck)
                XCTAssertNotEqual(version, project.lastUpgradeCheck)
                project.lastUpgradeCheck = PBXProject.Version(major: 12, minor: 0)
                XCTAssertNotNil(project.lastUpgradeCheck)
                XCTAssertEqual(project.lastUpgradeCheck?.major, 12)
                XCTAssertEqual(project.lastUpgradeCheck?.minor, 0)
                XCTAssertNotEqual(version, project.lastUpgradeCheck)

                let testURL = URL(fileURLWithPath: XcodeProjKitEditionTests.directory + resource.replacingOccurrences(of: "ok/", with: "") + "." + XcodeProj.pbxprojFileExtension)
                try proj.write(to: testURL)
                let testproj: XcodeProj = try XcodeProj(url: testURL)
                XCTAssertEqual(PBXProject.Version(major: 12, minor: 0), testproj.project.lastUpgradeCheck)


                assertContentsNotEqual(url, testURL)

            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("Missing resource \(resource)")
        }
    }

}
