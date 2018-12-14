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
	var identifier: Int

	static var identifierFactory = 0

	static func getUniqueIdentifier() -> Int {
		Card.identifierFactory += 1
		return Card.identifierFactory
	}

	init(identifier: Int) {
		self.identifier = Card.getUniqueIdentifier()
	}
}

