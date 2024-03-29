# XcodeProjKit

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-macOS_Linux-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Swift](https://github.com/phimage/XcodeProjKit/actions/workflows/swift.yml/badge.svg)](https://github.com/phimage/XcodeProjKit/actions/workflows/swift.yml)
[![Sponsor](https://img.shields.io/badge/Sponsor-%F0%9F%A7%A1-white.svg?style=flat)](https://github.com/sponsors/phimage)

Parse project file and write it to open step format.

Work also on simple plist in xml, binary or json format.

## Project description

Plist files could be in binary, xml or open step format. All could be parsed natively using `PropertyListSerialization`.

:warning: But you cannot be written back into open step format.

This project aim to
- check xcode project file. Error could occurs after merging file using git.
- rewrite the file into open step format, if you edit it using some command line like [plutil](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/plutil.1.html).

Alternatively you can use apple private framework DVTFoundation, like [Xcodeproj](https://github.com/CocoaPods/Xcodeproj) do.

## Usage

### Read

```swift
let xcodeProj = try XcodeProj(url: url)
let project: PBXProject = xcodeProj.project

let mainGroup: PBXGroup? = project.mainGroup
let targets: [PBXNativeTarget] = project.targets
let buildConfigurationList: XCConfigurationList? = project.buildConfigurationList
```

### Write

```swift
try xcodeProj.write(to: newURL, format: .openStep)
```

## Setup

### Using Swift Package Manager

```swift
let package = Package(
    name: "MyProject",
    dependencies: ["
        .package(url: "https://github.com/phimage/XcodeProjKit.git", from: "3.0.0"),
        ],
    targets: [
        .target(
            name: "MyProject",
            dependencies: ["XcodeProjKit"]),
        ]
)
```

### Using Carthage

Carthage is a decentralized dependency manager for Objective-C and Swift.

Add the project to your Cartfile.
```
github "phimage/XcodeProjKit"
```
Run carthage update and follow the additional steps in order to add MomXML to your project.

### Using Cocoapod

Add the project to your Podfile.
```
pod "XcodeProjKit"
```

### References

- http://danwright.info/blog/2010/10/xcode-pbxproject-files/
- http://www.monobjc.net/xcode-project-file-format.html
- https://github.com/apple/swift-package-manager/tree/master/Sources/Xcodeproj

### Thanks

- @Karumi for the test files : https://github.com/Karumi/Kin
- @allu22 for the PR

### Used by

- [iblinter](https://github.com/IBDecodable/IBLinter) a command line tool to check your storyboards
- [plistconvert](https://github.com/phimage/plistconvert) a command line tool to convert plist and pbxproj to different supported format (work on linux and macOS)
- [xprojup](https://github.com/phimage/xprojup) a command line tool to update xcode proj to latest version (to avoid warnings)
- [punic](https://github.com/phimage/punic) a command line tool too remove the usage of binary frameworks introduced by [Carthage](https://github.com/Carthage/Carthage) and to go back to developpement with sources.

### Contribute
- Fork
- Make PR
