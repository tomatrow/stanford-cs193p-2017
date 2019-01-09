//
//  ViewController.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = defaultConcentrationGame()

    var flipCount = 0 {
        didSet { flipCountLabel.text = "Flips: \(flipCount)" }
    }

    @IBOutlet var cardButtons: [UIButton]! {
        // UiOutletCollection has an unreliable order. So we tag and sort them.
        didSet { cardButtons.sort { $0.tag < $1.tag } }
    }

    @IBOutlet var flipCountLabel: UILabel!

    @IBAction func touchNewGame(_: Any) {
        game = defaultConcentrationGame()
        flipCount = 0
        emojiChoices = Theme.randomTheme().emoji
        updateViewFromModel()
    }

    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in Cardbuttons")
        }
    }

    func updateViewFromModel() {
        cardButtons.indices.forEach { index in
            let button = cardButtons[index]
            let card = game.deck[index]

            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }

    var emojiChoices = Theme.randomTheme().emoji

    var emoji = [Int: String]()

    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count))) // such typing
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }

        return emoji[card.identifier] ?? "?"
    }
}

extension ViewController {
    func defaultConcentrationGame() -> Concentration {
        return Concentration(numberOfPairsOfCards: cardButtons.count / 2)
    }
}

/// A set of card faces.
struct Theme {
    let emoji: [String]

    init(_ newEmoji: String) {
        self.init(newEmoji.map { String($0) })
    }

    init(_ newEmoji: [String]) {
        assert(newEmoji.count == 20)
        emoji = newEmoji
    }

    static let standard = [
        "flag": Theme("🏳️🏴🏁🚩🏳️‍🌈🇦🇫🇦🇽🇦🇱🇩🇿🇦🇸🇦🇩🇦🇴🇦🇮🇦🇶🇦🇬🇦🇷🇦🇲🇦🇼🇦🇺🇦🇹"),
        "animal": Theme("🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒"),
        "food": Theme("🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🍍🥥🥝🍅🍆🥑🥦🥒"),
        "sport": Theme("⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏸🥅🏒🏑🏏⛳️🏹🎣🥊🥋🎽"),
        "car": Theme("🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐🚚🚛🚜🛴🚲🛵🏍🚨🚔🚍"),
        "love": Theme("❤️🧡💛💚💙💜🖤💔❣️💕💞💓💗💖💘💝💟☮️✝️☪️"),
    ]

    static func randomTheme() -> Theme {
        return standard.values.shuffled().first!
    }
}
