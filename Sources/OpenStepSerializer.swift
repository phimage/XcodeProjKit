//
//  OpenStepSerializer.swift
//  XcodeProjKit
//
//  Created by Eric Marchand on 30/07/2017.
//  Copyright © 2017 AnOrgaName. All rights reserved.
//

import Foundation

class OpenStepSerializer {

    let projectName: String
    let projectFile: XcodeProj
    let lineEnding: String

    init(projectName: String, lineEnding: String = "\r\n", projectFile: XcodeProj) {
        self.projectName = projectName
        self.lineEnding = lineEnding
        self.projectFile = projectFile
    }

    func serialize() throws -> String {
        var lines = [
            "// !$*UTF8*$!",
            "{"
        ]

        for key in projectFile.dict.keys.sorted() {
            let val = projectFile.dict[key]!

            if key == "objects" {

                lines.append("\tobjects = {")

                // Group by isa
                let groupedObjects = projectFile.objects.dict.values
                    .grouped { $0.isa }
                    .sorted { $0.0 }

                // For each isa, a section
                for (isa, objects) in groupedObjects {
                    lines.append("")
                    lines.append("/* Begin \(isa) section */")

                    for object in objects.sorted(by: { $0.ref }) {

                        let multiline = isa != .buildFile && isa != .fileReference

                        let parts = try rows(type: isa, objKey: object.ref, multiline: multiline, fields: object.fields)
                        if multiline {
                            for line in parts {
                                lines.append("\t\t" + line)
                            }
                        } else {
                            lines.append("\t\t" + parts.joined(separator: ""))
                        }
                    }

                    lines.append("/* End \(isa) section */")
                }
                lines.append("\t};")
            } else {
                var comment = ""
                if key == "rootObject" {
                    comment = " /* Project object */"
                }
#if os(Linux)
                let row: String
                if let dict = val as? [AnyHashable: Any], dict.isEmpty { 
                    row = "\(key) = {\n}\(comment);" // print on linux give [:] ...
                } else {
                    row = "\(key) = \(val)\(comment);"
                }
#else
                let row = "\(key) = \(val)\(comment);"
#endif
                for line in row.components(separatedBy: "\n") {
                    lines.append("\t\(line)")
                }
            }
        }

        lines.append("}\(lineEnding)")
        return lines.joined(separator: lineEnding)
    }

    func comment(forKey key: String) -> String? {
        if key == projectFile.project.ref {
            return "Project object"
        }

        if let obj = projectFile.objects.dict[key] {
            if let buildFile = obj as? PBXBuildFile {
                if let buildPhase = self.projectFile.objects.buildPhaseByFileRef[key],
                    let group = comment(forKey: buildPhase.ref) {

                    if let fileRef = buildFile.fileRef?.ref {
                        if let fileRefComment = comment(forKey: fileRef) {
                            return "\(fileRefComment) in \(group)"
                        }
                        // else ...
                    } else {
                        return "(null) in \(group)"
                    }
                }
            } else if obj is XCConfigurationList {
                if let target = self.projectFile.project.targetsByConfigRef[key] {
                    return "Build configuration list for \(target.isa) \"\(target.name)\""
                }
                return "Build configuration list for PBXProject \"\(projectName)\""
            }
            return obj.comment
        }

        return nil
    }

    // swiftlint:disable:next function_body_length
    func objectValue(key: String, val: Any, multiline: Bool) throws -> [String] {
        var parts: [String] = []
        let keyStr = key.valueString

        if let valArr = val as? [String] {
            parts.append("\(keyStr) = (")

            var rows: [String] = []
            for valItem in valArr {
                let str = valItem.valueString

                var extraComment = ""
                if let comment = self.comment(forKey: valItem) {
                    extraComment = " /* \(comment) */"
                }

                rows.append("\(str)\(extraComment),")
            }
            if multiline {
                for part in rows {
                    parts.append("\t\(part)")
                }
                parts.append(");")
            } else {
                parts.append(rows.map { $0 + " "}.joined(separator: "") + "); ")
            }

        } else if let valArr = val as? [PBXObject.Fields] {
            parts.append("\(keyStr) = (")

            for valObj in valArr {
                if multiline {
                    parts.append("\t{")
                }

                for valKey in valObj.keys.sorted() {
                    if let valVal = valObj[valKey] {
                        let rows = try self.objectValue(key: valKey, val: valVal, multiline: multiline)

                        if multiline {
                            for part in rows {
                                parts.append("\t\t\(part)")
                            }
                        } else {
                            parts.append("\t" + rows.joined(separator: "") + "}; ")
                        }
                    } else {
                        assertionFailure("Missing val for \(valKey)")
                    }
                }

                if multiline {
                    parts.append("\t},")
                }
            }

            parts.append(");")

        } else if let valObj = val as? PBXObject.Fields {
            parts.append("\(keyStr) = {")

            for valKey in valObj.keys.sorted() {
                if let valVal = valObj[valKey] {
                    let rows = try self.objectValue(key: valKey, val: valVal, multiline: multiline)

                    if multiline {
                        for part in rows {
                            parts.append("\t\(part)")
                        }
                    } else {
                        parts.append(rows.joined(separator: "") + "}; ")
                    }
                } else {
                    assertionFailure("Missing val for \(valKey)")
                }
            }

            if multiline {
                parts.append("};")
            }

        } else {
            let str = "\(val)".valueString

            var extraComment = ""
            if let comment = self.comment(forKey: str) {
                extraComment = " /* \(comment) */"
            }

            if key == "remoteGlobalIDString" || key == "TestTargetID" {
                extraComment = ""
            }

            if multiline {
                parts.append("\(keyStr) = \(str)\(extraComment);")
            } else {
                parts.append("\(keyStr) = \(str)\(extraComment); ")
            }
        }

        return parts
    }

    func rows(type: Isa, objKey: String, multiline: Bool, fields: PBXObject.Fields) throws ->  [String] {

        var parts: [String] = []
        if multiline {
            parts.append("isa = \(type.rawValue);")
        } else {
            parts.append("isa = \(type.rawValue); ")
        }

        for key in fields.keys.sorted() where key != FieldKey.isa.rawValue {
            if let val = fields[key] {
                for part in try objectValue(key: key, val: val, multiline: multiline) {
                    parts.append(part)
                }
            } else {
                assertionFailure("missing \(key)")
            }
        }

        var objComment = ""
        if let comment = self.comment(forKey: objKey) {
            objComment = " /* \(comment) */"
        }

        let opening = "\(objKey)\(objComment) = {"
        let closing = "};"

        if multiline {
            var lines: [String] = []
            lines.append(opening)
            for part in parts {
                lines.append("\t\(part)")
            }
            lines.append(closing)
            return lines
        } else {
            return [opening + parts.joined(separator: "") + closing]
        }
    }
}
