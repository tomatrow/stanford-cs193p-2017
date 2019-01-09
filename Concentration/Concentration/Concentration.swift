//
//  Concentration.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import Foundation

class Concentration {
    var score = 0
    var flipCount = 0
    var deck: [Card]

    var indexOfOnlyFaceUpCard: Int?

    func chooseCard(at index: Int) {
        // if the card is matched, then chooseing it is pointless
        guard !deck[index].isMatched else { return }

        // count the flip
        flipCount += 1

        // three cases: (0) no cards up (1) one card up (2) two cards up

        // one card up, and we are not choosing it
        if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index {
            // one card up

            match(matchIndex, index)

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

    // check for match, and mark if found
    @discardableResult
    private func match(_ left: Int, _ right: Int) -> Bool {
        assert(deck.indices.contains(left))
        assert(deck.indices.contains(right))
        assert(left != right)

        // check for match
        if deck[left].identifier == deck[right].identifier {
            // it was a match => mark them
            deck[left].isMatched = true
            deck[right].isMatched = true
            score += 2
            return true
        } else {
            [deck[left], deck[right]].filter { $0.seen }.forEach { _ in score -= 1 }
            deck[left].seen = true
            deck[right].seen = true
            return false
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
