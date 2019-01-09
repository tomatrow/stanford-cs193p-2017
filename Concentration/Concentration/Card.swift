//
//  Card.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var seen = false
    private var identifier: Int

    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }

    init() {
        identifier = Card.getUniqueIdentifier()
    }
}

extension Card: Equatable {
    static func == (_ left: Card, _ right: Card) -> Bool {
        return left.identifier == right.identifier
    }
}

extension Card: Hashable {
    var hashValue: Int {
        return identifier
    }
}
