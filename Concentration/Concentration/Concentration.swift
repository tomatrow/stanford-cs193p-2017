//
//  Concentration.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import Foundation

class Concentration {
    private(set) var score = 0
    private(set) var flipCount = 0
    private(set) var deck: [Card]

    private var indexOfOnlyFaceUpCard: Int? {
        get {
            var found: Int?
            for index in deck.indices {
                if deck[index].isFaceUp {
                    if found == nil {
                        found = index
                    } else {
                        return nil
                    }
                }
            }
            return found
        }
        set {
            for index in deck.indices {
                deck[index].isFaceUp = index == newValue
            }
        }
    }

    func chooseCard(at index: Int) {
        // if the card is matched, then chooseing it is pointless
        guard !deck[index].isMatched else { return }

        // count the flip
        flipCount += 1

        // three cases: (0) no cards up (1) one card up (2) two cards up

        if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index {
            // case (1)
            match(matchIndex, index)
            deck[index].isFaceUp = true // flip chosen card
        } else {
            // case (0) or (2)
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
        if deck[left] == deck[right] {
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
            .map { _ in Card() }
            .map { [$0, $0] } // create pairs
            .reduce([], +) // flatten

        // randomize order
        deck.shuffle()
    }
}
