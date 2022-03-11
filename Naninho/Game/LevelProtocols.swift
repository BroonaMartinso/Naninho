//
//  LevelInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 07/03/22.
//

import Foundation

protocol LevelInteracting {
    
    var maxLevel: Int { get }
    var currentLevel: Int { get }
    var completedLevels: [Int:Int] { get }
    var starsObtained: Int { get }
    var maxObtainableStars: Int { get }
    
    func startCurrentLevel()
    func playNextLevel()
    func replayLevel()
    func completeLevel(timeRemaining: Double)
    func getStarsFor(level: Int) -> Int
    func setLevel(to level: Int)
    
    func addListener(_ listener: LevelChangeListener)
}

protocol LevelPresenting {

    func startLevel(with configuration: LevelConfiguration)
    func showEndScreen(for result: LevelEndStatus)
    
}

protocol LevelWorking {
    
    func getConfiguration(forLevel level: Int) -> LevelConfiguration
    func getStars(forLevel level: Int, timeRemaining: Double) -> Int
    
}
