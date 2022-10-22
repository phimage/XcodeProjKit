//
//  PropertyList.swift
//  
//
//  Created by emarchand on 22/10/2022.
//

import Foundation

open class PropertyList {

    public enum Format {
        case binary
        case xml
        case json
        case openStep

        public func toPropertyListformat() -> PropertyListSerialization.PropertyListFormat? {
            switch self {
            case .binary:
                return .binary
            case .xml:
                return .xml
            case .openStep:
                return .openStep
            case .json:
                return nil
            }
        }

        public init(_ format: PropertyListSerialization.PropertyListFormat) {
            switch format {
            case .binary:
                self = .binary
            case .xml:
                self = .xml
            case .openStep:
                self = .openStep
            @unknown default:
                fatalError("unknown format")
            }
        }

        public init?(_ format: PropertyListSerialization.PropertyListFormat?) {
            if let format = format {
                self.init(format)
            } else {
                return nil
            }
        }

        public init?(string: String) {
            switch string.lowercased() {
            case "openstep":
                self = .openStep
            case "xml", "xml1":
                self = .xml
            case "json":
                self = .json
            case "binary", "binary1":
                self = .binary
            default:
                return nil
            }
        }

    }

    public let dict: PBXObject.Fields
    public let format: Format

    public init(dict: PBXObject.Fields, format: Format) throws {
        self.dict = dict
        self.format = format
    }

    public convenience init(propertyListData data: Data) throws {
        let format: Format
        let obj: Any
        if data.first == 123 { // start with {
            obj = try JSONSerialization.jsonObject(with: data)
            format = .json
        } else {
            var propertyListFormat: PropertyListSerialization.PropertyListFormat = .binary
            obj = try PropertyListSerialization.propertyList(from: data, options: [], format: &propertyListFormat)
            format = .init(propertyListFormat)
        }

        guard let dict = obj as? PBXObject.Fields else {
            throw XcodeProjError.invalidData(object: obj)
        }

        try self.init(dict: dict, format: format)
    }

    public convenience init(url: URL) throws {
        assert(url.isFileURL)
        do {
            let data = try Data(contentsOf: url)
            try self.init(propertyListData: data)
        } catch let error as XcodeProjError {
            throw error
        } catch {
            throw XcodeProjError.failedToReadFile(error: error)
        }
    }

     // MARK: - Write
    public func write(to url: URL,
                      format: Format? = nil,
                      projectName: String? = nil,
                      lineEnding: String? = nil,
                      atomic: Bool = true) throws {
        let format = format ?? .xml
        if format == .openStep {
            try XcodeProj(dict: self.dict, format: Format.openStep).write(to: url,
                                                                         format: format,
                                                                         projectName: projectName,
                                                                         lineEnding: lineEnding,
                                                                         atomic: atomic)
        } else if let propertyListformat = format.toPropertyListformat() {
            let data = try PropertyListSerialization.data(
                fromPropertyList: dict,
                format: propertyListformat,
                options: 0)
#if os(Linux)
            try data.write(to: url, options: []) // error no attomic on linux
#else
            try data.write(to: url, options: atomic ? [.atomicWrite] : [])
#endif
        } else if format == .json {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
#if os(Linux)
            try data.write(to: url, options: []) // error no attomic on linux
#else
            try data.write(to: url, options: atomic ? [.atomicWrite] : [])
#endif
        }
    }

    public func data(projectName: String? = nil) throws -> Data {
        if format == .openStep {
            return try XcodeProj(dict: self.dict, format: Format.openStep).data(projectName: projectName)
        } else if let propertyListformat = format.toPropertyListformat() {
            return try PropertyListSerialization.data(fromPropertyList: dict, format: propertyListformat, options: 0)
        } else if format == .json {
            return try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
        return Data()
    }

}
