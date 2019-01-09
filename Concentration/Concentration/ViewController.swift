//
//  ViewController.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = defaultConcentrationGame()

    @IBOutlet private var cardButtons: [UIButton]! {
        // UiOutletCollection has an unreliable order. So we tag and sort them.
        didSet { cardButtons.sort { $0.tag < $1.tag } }
    }

    @IBOutlet private var flipCountLabel: UILabel!

    @IBAction private func touchNewGame(_: Any) {
        game = defaultConcentrationGame()

        emojiChoices = Theme.randomTheme().emoji
        updateViewFromModel()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in Cardbuttons")
        }
    }

    private func updateViewFromModel() {
        flipCountLabel.text = "Score: \(game.score)"
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

    private var emojiChoices = Theme.randomTheme().emoji

    private var emoji = [Card: String]()

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4Random()
            emoji[card] = emojiChoices.remove(at: randomIndex)
        }

        return emoji[card] ?? "?"
    }
}

extension ViewController {
    private func defaultConcentrationGame() -> Concentration {
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

extension Int {
    func arc4Random() -> Int {
        // such typing
        return Int(arc4random_uniform(UInt32(self)))
    }
}
