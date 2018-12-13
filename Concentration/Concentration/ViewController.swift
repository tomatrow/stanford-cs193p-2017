//
//  ViewController.swift
//  Concentration
//
//  Created by AJ Caldwell on 12/13/18.
//  Copyright © 2018 optional(default). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var flipCount = 0 {
		didSet {
			flipCountLabel.text = "Flips: \(flipCount)"
		}
	}
	
	@IBOutlet var cardButtons: [UIButton]! {
		//UiOutletCollection order is unreliable, so we apply and then sort by tag
		didSet { cardButtons.sort { $0.tag < $1.tag } }
	}
	
	let emojiChoices = ["🎃","👻","🎃","👻"]
	@IBOutlet weak var flipCountLabel: UILabel!
	
	@IBAction func touchCard(_ sender: UIButton) {
		flipCount += 1
		if let cardNumber = cardButtons.index(of: sender) {
			print("cardnumber = \(cardNumber)")
			flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
		} else {
			print("Chosen card was not in Cardbuttons")
		}
	}
	
	func flipCard(withEmoji emoji: String, on button: UIButton) {
		if button.currentTitle == emoji {
			button.setTitle("", for: .normal)
			button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
		} else {
			button.setTitle(emoji, for: .normal)
			button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		}
	}
}
