//
//  LevelHandler.swift
//  Naninho
//
//  Created by Marco Zulian on 04/02/22.
//

import Foundation
import GameKit

class LevelHandler {
    
    static var shared: LevelHandler = LevelHandler()
    private(set) var currentLevel: Int = 0 {
        didSet {
            for listener in listeners {
                listener.handleLevelChange(to: currentLevel)
            }
            UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
        }
    }
    private var maxLevel: Int = 0{
        didSet {
            UserDefaults.standard.set(maxLevel, forKey: "maxLevel")
        }
    }
    private var listeners: [LevelChangeListener] = []
    var completedLevels: [Int: Int] = [:] {
        didSet{
            let encoder = PropertyListEncoder()
            if let data = try? encoder.encode(completedLevels) {
                UserDefaults.standard.set(data, forKey: "data")
            }
        }
    }
    var levelSpeed: Double {
        
        if currentLevel == 0 {
            return 0
        }
        else {
            return Double(currentLevel) * 50.0}
    }
    var numberOfSpikes: Int {
        if currentLevel == 0 {
            return 3}
        else {
            return 5 + currentLevel}
        
    }
    var timeNeededForAFullCircle: Double {
        5 - 0.5 * Double(currentLevel)
    }
    var timeToCompleteCurrLevel: Double {
        60
    }
    
    private init() {
        currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
        maxLevel = UserDefaults.standard.integer(forKey: "maxLevel")
        let decoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "completedLevels"),
           let intDictionary = try? decoder.decode([Int : Int].self, from: data){
            completedLevels = intDictionary
        }
    }
    
    static func nextLevel(timeRemaining: Double) {
        if shared.currentLevel != 0 {
            let startsGained = getStarsForCurrentLevel(timeRemaining: timeRemaining)
            registerStarsForCurrentLevel(amount: startsGained)
        }
        
        shared.currentLevel += 1
        if  shared.maxLevel < shared.currentLevel {
            shared.maxLevel =  shared.currentLevel
            shared.updateScore (with: shared.maxLevel)
            
        }
    
    }
    
    func updateScore(with value:Int)
    {
        if (GameViewController.gcEnabled)
        { GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [GameViewController.gcDefaultLeaderBoard], completionHandler: {error in})
        }
    }
    static func setLevel(to level: Int) {
        if level > 0 && level <= shared.maxLevel {
            shared.currentLevel = level
        }
    }
    
    func addListener(_ listener: LevelChangeListener) {
        listeners.append(listener)
    }
    private static func getStarsForCurrentLevel(timeRemaining: Double) -> Int{
        var starsGained: Int = 0
        
        if timeRemaining > shared.timeToCompleteCurrLevel * 0.5 {
            starsGained = 3
        } else if timeRemaining > shared.timeToCompleteCurrLevel * 0.25 {
            starsGained = 2
        } else {
            starsGained = 1
        }
        
        return starsGained
    }
    
    private static func registerStarsForCurrentLevel(amount stars: Int) {
        if let previousStars = shared.completedLevels[shared.currentLevel] {
            shared.completedLevels[shared.currentLevel] = max(previousStars, stars)
        } else {
            shared.completedLevels[shared.currentLevel] = stars
        }
        print(shared.completedLevels)
    }
}

protocol LevelChangeListener: AnyObject {
    func handleLevelChange(to newLevel: Int)
}
