//
//  Concentration.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import Foundation

class Concentration {
    var deck: [Card]

    var indexOfOnlyFaceUpCard: Int?

    func chooseCard(at index: Int) {
        // if the card is matched, then chooseing it is pointless
        guard !deck[index].isMatched else { return }

        // three cases: (0) no cards up (1) one card up (2) two cards up

        // one card up, and we are not choosing it
        if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index {
            // one card up

            // check for match, and mark if found
            if deck[matchIndex].identifier == deck[index].identifier {
                deck[matchIndex].isMatched = true
                deck[index].isMatched = true
            }

            deck[index].isFaceUp = true // flip chosen card
            indexOfOnlyFaceUpCard = nil // now more than two cards are up
        } else {
            // no cards or two cards up

            // flip all cards down except for our choice
            deck.indices.forEach { deck[$0].isFaceUp = false }
            deck[index].isFaceUp = true
            indexOfOnlyFaceUpCard = index
        }
    }

    init(numberOfPairsOfCards: Int) {
        // create deck
        deck = (0 ..< numberOfPairsOfCards)
            .map { Card(identifier: $0) }
            .map { [$0, $0] } // two copies of each card
            .reduce([], +) // flatten

        // randomize order
        deck.shuffle()
    }
}
