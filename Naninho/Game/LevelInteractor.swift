//
//  LevelHandler.swift
//  Naninho
//
//  Created by Marco Zulian on 04/02/22.
//

import Foundation
import GameKit

class LevelHandler: NSObject, LevelInteracting {
    
    func startLevel() {
        if let configuration = worker?.getConfiguration(forLevel: currentLevel) {
            presenter?.startLevel(with: configuration)
        }
    }
    
    func completeLevel(timeRemaining: Double) {
        let previouslyObtainedStars = completedLevels[currentLevel] ?? 0
        let gameStatus: EndGameStatus = timeRemaining >= 0 ? .win : .lose
        let stars = worker?.getStars(forLevel: currentLevel, timeRemaining: timeRemaining) ?? 0
        
        let result = LevelEndStatus(level: currentLevel,
                                    status: gameStatus,
                                    stars: max(stars, previouslyObtainedStars))
        presenter?.showEndScreen(for: result)
        
        if timeRemaining >= 0 {
            currentLevel += 1
            if  maxLevel < currentLevel {
                maxLevel =  currentLevel
            }
        }
    }
    
    
    static var shared: LevelHandler = LevelHandler()
    private var presenter: LevelPresenting?
    private var worker: LevelWorking?
    
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
    
    override init() {
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
    
    init(worker: LevelWorking, presenter: LevelPresenting) {
        rankingInteractor = RankingInteractor(worker: RankingWorker())
        persistenceInteractor = PersistenceInteractor(worker: UserDefaultsWorker())
        self.worker = worker
        self.presenter = presenter
        
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

extension LevelHandler: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(2, maxLevel + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LevelSelectionCell
        let currLevel = max(1, maxLevel) - indexPath.row
        
        cell.star = completedLevels[currLevel] ?? 0
        cell.nivel = currLevel
        if currLevel != currentLevel {
            cell.deselect()
        }
        return cell
    }
}
