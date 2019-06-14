//
//  Person.swift
//  PairRandomizer
//
//  Created by Will morris on 6/14/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import Foundation

struct Person {
    let name: String
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
}
