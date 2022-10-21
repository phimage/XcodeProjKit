//
//  Utils.swift
//  
//
//  Created by phimage on 25/10/2020.
//

import Foundation
import XCTest

class Utils {

    static let bundle = Bundle(for: Utils.self)

    static let testURL: URL = {
        #if compiler(>=5.3)
        let thisFilePath = #filePath
        #else
        let thisFilePath = #file
        #endif
        return URL(fileURLWithPath: thisFilePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Tests")
    }()

    static func url(forResource resource: String, withExtension ext: String) -> URL? {
        #if !os(Linux)
        if let url = bundle.url(forResource: resource, withExtension: ext) {
            return url
        }
        #endif
        var url = URL(fileURLWithPath: "Tests/\(resource).\(ext)")
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        }
        url = testURL.appendingPathComponent(resource).appendingPathExtension(ext)
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        }
        return nil
    }
}

extension XCTestCase {

    func url(forResource resource: String, withExtension ext: String) -> URL? {
        return Utils.url(forResource: resource, withExtension: ext)
    }

    func assertContentsEqual(_ url: URL, _ testURL: URL ) {
        do {
            let contents = try String(contentsOf: url)
            let testContents = try String(contentsOf: testURL)
            XCTAssertEqual(contents, testContents)
        } catch {
            XCTFail("\(error)")
        }
    }

    func assertContentsNotEqual(_ url: URL, _ testURL: URL ) {
        do {
            let contents = try String(contentsOf: url)
            let testContents = try String(contentsOf: testURL)
            XCTAssertNotEqual(contents, testContents)
        } catch {
            XCTFail("\(error)")
        }
    }

}

extension String {
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
