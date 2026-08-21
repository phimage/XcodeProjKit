//
//  XcodeProjKitModernTests.swift
//  XcodeProjKitTests
//
//  Decoding of object types introduced by recent Xcode versions, and graceful
//  handling of unknown/future `isa` values.
//

import XCTest
@testable import XcodeProjKit

class XcodeProjKitModernTests: XCTestCase {

    static let directory = NSTemporaryDirectory() + "xcodeproj-modern/"

    static override func setUp() {
        try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)
    }

    private func load(_ resource: String) -> XcodeProj? {
        guard let url = url(forResource: resource, withExtension: XcodeProj.pbxprojFileExtension) else {
            XCTFail("Missing resource \(resource)")
            return nil
        }
        do {
            return try XcodeProj(url: url)
        } catch {
            XCTFail("\(error)")
            return nil
        }
    }

    // MARK: - Decode Xcode 16 file-system synchronized groups

    func testDecodeFileSystemSynchronizedRootGroup() {
        guard let proj = load("ok/xcode16syncgroup.project") else { return }
        let groups = proj.objects.dict.values.of(type: PBXFileSystemSynchronizedRootGroup.self)
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups.first?.path, "Xcode16BuildConfigurations")
    }

    func testDecodeSynchronizedExceptionSets() {
        guard let proj = load("ok/xcode16syncexceptions.project") else { return }
        XCTAssertEqual(proj.objects.dict.values.of(type: PBXFileSystemSynchronizedRootGroup.self).count, 1)

        let buildFileExceptions = proj.objects.dict.values.of(type: PBXFileSystemSynchronizedBuildFileExceptionSet.self)
        XCTAssertEqual(buildFileExceptions.count, 1)
        XCTAssertEqual(buildFileExceptions.first?.membershipExceptions, ["Exception/Exception.swift"])
        XCTAssertNotNil(buildFileExceptions.first?.target)

        let phaseExceptions = proj.objects.dict.values.of(type: PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet.self)
        XCTAssertEqual(phaseExceptions.count, 1)
        XCTAssertNotNil(phaseExceptions.first?.buildPhase)
    }

    // MARK: - Decode Xcode 15 local Swift package references

    func testDecodeLocalSwiftPackageReference() {
        guard let proj = load("ok/xclocalswiftpackage.project") else { return }
        let refs = proj.objects.dict.values.of(type: XCLocalSwiftPackageReference.self)
        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs.first?.relativePath, "MyLocalPackage")
        XCTAssertEqual(refs.first?.comment, "XCLocalSwiftPackageReference \"MyLocalPackage\"")
    }

    // MARK: - Robustness: an unknown/future isa must not crash and must round-trip

    func testUnknownIsaRoundTrips() throws {
        guard let url = url(forResource: "ok/xcode16syncgroup.project", withExtension: XcodeProj.pbxprojFileExtension) else {
            XCTFail("missing resource")
            return
        }
        let futureIsa = "PBXSomeFutureUnknownType"
        let original = try String(contentsOf: url)
        let mutated = original.replacingOccurrences(of: "isa = PBXFileSystemSynchronizedRootGroup;",
                                                     with: "isa = \(futureIsa);")
        let mutatedURL = URL(fileURLWithPath: XcodeProjKitModernTests.directory + "unknownisa.pbxproj")
        try mutated.write(to: mutatedURL, atomically: true, encoding: .utf8)

        // Parsing must not crash on the unknown isa.
        let proj = try XcodeProj(url: mutatedURL)

        // The unknown object is kept as a generic PBXObject, identifiable by its raw isa string.
        let unknowns = proj.objects.dict.values.filter { $0.isaString == futureIsa }
        XCTAssertEqual(unknowns.count, 1)
        XCTAssertTrue(type(of: unknowns[0]) == PBXObject.self)

        // And it round-trips: writing keeps the unknown isa.
        let outURL = URL(fileURLWithPath: XcodeProjKitModernTests.directory + "unknownisa.out.pbxproj")
        try proj.write(to: outURL)
        let out = try String(contentsOf: outURL)
        XCTAssertTrue(out.contains("isa = \(futureIsa);"))
    }
}
