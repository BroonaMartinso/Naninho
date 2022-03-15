//
//  LevelHandler.swift
//  Naninho
//
//  Created by Marco Zulian on 04/02/22.
//

import Foundation
import GameKit

class LevelInteractor: NSObject, LevelInteracting {
    
    private var presenter: LevelPresenting?
    private var worker: LevelWorking?
    private var rankingInteractor: RankingInteracting
    private var persistenceInteractor: PersistenceInteracting
    
    private(set) var maxLevel: Int = 0
    private var listeners: [LevelChangeListener] = []
    private(set) var completedLevels: [Int: Int] = [:]
    private(set) var currentLevel: Int = 0 {
        didSet {
            for listener in listeners {
                listener.handleLevelChange(to: currentLevel, stars: getStarsFor(level: currentLevel))
            }
        }
    }
    
    var maxObtainableStars: Int {
        return (maxLevel) * 3
    }
    
    var starsObtained: Int {
        var totalStars = 0
        for level in completedLevels {
            totalStars += level.value
        }
        return totalStars
    }
    
    init(worker: LevelWorking? = nil, presenter: LevelPresenting? = nil) {
        rankingInteractor = RankingInteractor(worker: RankingWorker())
        persistenceInteractor = PersistenceInteractor(worker: UserDefaultsWorker())
        self.worker = worker
        self.presenter = presenter
        
        if let completed = persistenceInteractor.retrieveCompletedLevels() {
            self.completedLevels = completed
            print(completedLevels)
        }
        if let maxLevel = persistenceInteractor.retrieveMaxLevel() {
            self.maxLevel = maxLevel
            print(maxLevel)
        }
        if let currLevel = persistenceInteractor.retrieveCurrentLevel() {
            self.currentLevel = currLevel
            print(currentLevel)
        }
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
    
    func startCurrentLevel() {
        if let configuration = worker?.getConfiguration(forLevel: currentLevel) {
            presenter?.startLevel(with: configuration)
        }
    }
    
    func replayLevel() {
        startCurrentLevel()
    }
    
    func playNextLevel() {
        currentLevel += 1
        startCurrentLevel()
    }
    
    func completeLevel(timeRemaining: Double) {
        let previouslyObtainedStars = completedLevels[currentLevel] ?? 0
        let stars = worker?.getStars(forLevel: currentLevel, timeRemaining: timeRemaining) ?? 0
        completedLevels[currentLevel] = max(stars, previouslyObtainedStars)
        
        let gameStatus: EndGameStatus = timeRemaining >= 0 ? .win : .lose
            
        let result = LevelEndStatus(level: currentLevel,
                                    status: gameStatus,
                                    stars: max(stars, previouslyObtainedStars))
        presenter?.showEndScreen(for: result)
        
        if gameStatus == .win {
            maxLevel = max(maxLevel, currentLevel + 1)
            if gameStatus == .win {
                persistenceInteractor.saveCurrentState(currentLevel: currentLevel, maxLevel: maxLevel, completedLevels: completedLevels)
                rankingInteractor.updateRecords(levelRecord: maxLevel, starsRecord: starsObtained)
            }
        }
    }
}

protocol LevelChangeListener: AnyObject {
    func handleLevelChange(to newLevel: Int, stars: Int)
}
