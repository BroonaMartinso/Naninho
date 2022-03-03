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
        }
    }
    var maxLevel: Int = 0
    private var rankingInteractor: RankingInteracting
    private var persistenceInteractor: PersistenceInteracting
    private var listeners: [LevelChangeListener] = []
    private(set) var completedLevels: [Int: Int] = [:]
    
    var maxAchieavableStars: Int {
        return (maxLevel) * 3
    }
    
    var obtainedStars: Int {
        var totalStars = 0
        for level in completedLevels {
            totalStars += level.value
        }
        return totalStars
    }
    
    var levelSpeed: Double {
        if currentLevel == 0 {
            return 0
        }
        else {
            let minSpeed = 100 + 25 * currentLevel / 4
            let deltaSpeed = max(0, 200 - 20 * currentLevel / 4)
            return Double(minSpeed) + Double(deltaSpeed) * sigmoid(x: Double(currentLevel / 4), beta: 0.5)
        }
    }
    
    var numberOfSpikes: Int {
        if currentLevel == 0 {
            return 4
        }
        else {
            return min(8, 5 + (currentLevel / 4))
        }
    }
    
    var timeNeededForAFullCircle: Double {
        max(1, 10 - 0.25 * (Double(currentLevel.quotientAndRemainder(dividingBy: 4).quotient)))
    }
    
    var timeToCompleteCurrLevel: Double {
        50 + 0.15 * Double(currentLevel)
    }
    
    var timePenalty: Double {
        5 + 0.05 * Double(currentLevel)
    }
    
    private init() {
        rankingInteractor = RankingInteractor(worker: RankingWorker())
        persistenceInteractor = PersistenceInteractor(worker: UserDefaultsWorker())
        
        if let completed = persistenceInteractor.retrieveCompletedLevels() {
            completedLevels = completed
        }
        if let maxLevel = persistenceInteractor.retrieveMaxLevel() {
            self.maxLevel = maxLevel
        }
        if let currLevel = persistenceInteractor.retrieveCurrentLevel() {
            self.currentLevel = currLevel
        }
    }
    
    func nextLevel(timeRemaining: Double) {
        if currentLevel != 0 {
            let startsGained = getStarsForCurrentLevel(timeRemaining: timeRemaining)
            registerStarsForCurrentLevel(amount: startsGained)
        }
        
        currentLevel += 1
        if  maxLevel < currentLevel {
            maxLevel =  currentLevel
        }
    
        persistenceInteractor.saveCurrentState()
        rankingInteractor.updateRecords()
    }
    
    func getStarsFor(level: Int) -> Int {
        return completedLevels[level] ?? 0
    }
    
    func setLevel(to level: Int) {
        currentLevel = level
        if level > 0 && level <= maxLevel {
            currentLevel = level
        }
    }
    
    func addListener(_ listener: LevelChangeListener) {
        listeners.append(listener)
    }
    
    private func getStarsForCurrentLevel(timeRemaining: Double) -> Int{
        var starsGained: Int = 0
        
        if timeRemaining > timeToCompleteCurrLevel * 0.5 {
            starsGained = 3
        } else if timeRemaining > timeToCompleteCurrLevel * 0.25 {
            starsGained = 2
        } else {
            starsGained = 1
        }
        
        return starsGained
    }
    
    private func registerStarsForCurrentLevel(amount stars: Int) {
        if let previousStars = completedLevels[currentLevel] {
            completedLevels[currentLevel] = max(previousStars, stars)
        } else {
            completedLevels[currentLevel] = stars
        }
    }
    
    func sigmoid(x: Double, beta: Double = 1.0) -> Double {
        let eulerConstant = 0.577
        return 1.0 / (1.0 + pow(eulerConstant, beta*x))
    }
}

protocol LevelChangeListener: AnyObject {
    func handleLevelChange(to newLevel: Int)
}
