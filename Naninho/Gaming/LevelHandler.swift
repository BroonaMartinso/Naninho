//
//  LevelHandler.swift
//  Naninho
//
//  Created by Marco Zulian on 04/02/22.
//

import Foundation

class LevelHandler {
    
    static var shared: LevelHandler = LevelHandler()
    private(set) var currentLevel: Int = 1
    private var maxLevel: Int = 1
    
    var levelSpeed: Double {
        Double(currentLevel) * 50.0
    }
    var numberOfSpikes: Int {
        5 + currentLevel
    }
    var timeNeededForAFullCircle: Double {
        5 - 0.5 * Double(currentLevel)
    }
    var timeToCompleteCurrLevel: Double {
        60
    }
    
    private init() {}
    
    static func nextLevel() {
        shared.currentLevel += 1
        shared.maxLevel = max(shared.maxLevel, shared.currentLevel)
    }
    
    static func setLevel(to level: Int) {
        if level > 0 && level <= shared.maxLevel {
            shared.currentLevel = level
        }
    }
}
