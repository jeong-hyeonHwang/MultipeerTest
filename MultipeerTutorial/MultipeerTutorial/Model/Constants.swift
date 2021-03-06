//
//  Constants.swift
//  MultipeerTutorial
//
//  Created by íŠė í on 2022/07/14.
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
        return "đ"
    case "Surprising":
        return "đŽ"
    case "Congrats":
        return "đ"
    case "LEGO":
        return "đĨ"
    case "Idk":
        return "đ¤"
    case "Good":
        return "đ"
    default:
        return "*NIL*"
    }

}
