//
//  Menu.swift
//  Naninho
//
//  Created by Marco Zulian on 03/02/22.
//

import Foundation
import SpriteKit

enum Transition {
    case introToGame
    case endScreenToIntro
    case gameToWin
    case gameToLose
    case toLevelSelect
    case winToNextLevel
    case repeatLevel
    case dismissLevelPopup
    case pauseToMainMenu
    case pauseToContinue
    case pauseToReplay
    case gameToPause
    case introRanking
}
