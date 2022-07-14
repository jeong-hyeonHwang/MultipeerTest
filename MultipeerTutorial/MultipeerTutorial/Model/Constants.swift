//
//  Constants.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height

enum NamedEmoji: String, CaseIterable {
    case Marvelous, Surprising, Congrats, LEGO, Idk, Good
}

func emojiIs(s: String) -> String {
    switch s {
    case "Marvelous":
        return "👏"
    case "Surprising":
        return "😮"
    case "Congrats":
        return "🎉"
    case "LEGO":
        return "🔥"
    case "Idk":
        return "🤔"
    case "Good":
        return "👍"
    default:
        return "*NIL*"
    }

}
