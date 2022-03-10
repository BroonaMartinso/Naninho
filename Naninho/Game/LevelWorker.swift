//
//  LevelWorker.swift
//  Naninho
//
//  Created by Marco Zulian on 07/03/22.
//

import Foundation

class LevelWorker: LevelWorking {
    
    func getConfiguration(forLevel level: Int) -> LevelConfiguration {
        let minSpeed = 100 + 25 * level / 4
        let deltaSpeed = max(0, 200 - 20 * level / 4)
        let speed = level == 0 ? 0 : Double(minSpeed) + Double(deltaSpeed) * sigmoid(x: Double(level / 4), beta: 0.5)
        
        let numberOfSpikes = level == 0 ? 4 : min(8, 5 + (level / 4))
        let timeToCompleteAFullCicle = max(1, 10 - 0.25 * (Double(level.quotientAndRemainder(dividingBy: 4).quotient)))
        let timeForLevel = 50 + 0.15 * Double(level)
        let penalty = 5 + 0.05 * Double(level)
        
        return LevelConfiguration(level: level,
                                  speed: speed,
                                  numberOfSpikes: numberOfSpikes,
                                  timeNeededForAFullCircle: timeToCompleteAFullCicle,
                                  time: timeForLevel,
                                  timePenalty: penalty)
    }
    
    func getStars(forLevel level: Int, timeRemaining: Double) -> Int {
        if timeRemaining <= 0 { return 0 }
        
        var starsGained: Int = 0
        let timeForLevel = 50 + 0.15 * Double(level)
        
        if timeRemaining > timeForLevel * 0.5 {
            starsGained = 3
        } else if timeRemaining > timeForLevel * 0.25 {
            starsGained = 2
        } else {
            starsGained = 1
        }
        
        return starsGained
    }
    
    private func sigmoid(x: Double, beta: Double = 1.0) -> Double {
        let eulerConstant = 0.577
        return 1.0 / (1.0 + pow(eulerConstant, beta*x))
    }
}
