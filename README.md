# XcodeProjKit

Parse project file and write it to open step format.

## Project description

Plist files could be in binary, xml or open step format. All could be parsed natively using `PropertyListSerialization`.

:warning: But you cannot write into open step format.

This project aim to
- check xcode project file. Error could occurs after merging file using git.
- rewrite the file into open step format, if you edit it using some command line like [plutil](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/plutil.1.html).

Alternatively you can use apple private framework DVTFoundation, like [Xcodeproj](https://github.com/CocoaPods/Xcodeproj) do.

## Setup

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

### Using Swift Package Manager

...

### Referenes

- http://danwright.info/blog/2010/10/xcode-pbxproject-files/
- http://www.monobjc.net/xcode-project-file-format.html
- https://github.com/apple/swift-package-manager/tree/master/Sources/Xcodeproj

### Thanks

- @Karumi for the test files : https://github.com/Karumi/Kin

### TODO

- Make a command line tools

### Contribute
- Fork
- Make PR
