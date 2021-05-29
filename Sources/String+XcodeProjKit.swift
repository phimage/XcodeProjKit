//
//  String+XcodeProjKit.swift
//  XcodeProjKit
//
//  Created by Eric Marchand on 30/07/2017.
//  Copyright © 2017 AnOrgaName. All rights reserved.
//

import Foundation

// swiftlint:disable:next force_try
let nonescapeRegex = try! NSRegularExpression(pattern: "^[a-z0-9_\\$\\.\\/]+$", options: .caseInsensitive)
let specialRegexes: [(String, NSRegularExpression)] = ["\\\\", "\\\"", "\\n", "\\r", "\\t"].compactMap { string in
    if let regular = try? NSRegularExpression(pattern: string, options: []) {
        return (string, regular)
    } else {
        return nil
    }
}

extension String {

    var valueString: String {
        var str = self
        for (replacement, regex) in specialRegexes {
            let range = NSRange(location: 0, length: str.utf16.count)
            let template = NSRegularExpression.escapedTemplate(for: replacement)
            str = regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: template)
        }

        let range = NSRange(location: 0, length: str.utf16.count)
        if nonescapeRegex.firstMatch(in: str, options: [], range: range) != nil {
            return str
        }

        return "\"\(str)\""
    }
}
