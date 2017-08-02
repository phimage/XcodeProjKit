//
//  Sequence.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved
//

import Foundation

extension Sequence {

    func of<T>(type: T.Type) -> [T] {
        return self.flatMap { $0 as? T }
    }

    func grouped<Key>(by keySelector: (Iterator.Element) -> Key) -> [Key : [Iterator.Element]] {
        var groupedBy: [Key: [Iterator.Element]] = [:]

        for element in self {
            let key = keySelector(element)
            var array = groupedBy.removeValue(forKey: key) ?? []
            array.append(element)
            groupedBy[key] = array
        }

        return groupedBy
    }

    func sorted<U: Comparable>(by keySelector: (Iterator.Element) -> U) -> [Iterator.Element] {
        return self.sorted { keySelector($0) < keySelector($1) }
    }

}
