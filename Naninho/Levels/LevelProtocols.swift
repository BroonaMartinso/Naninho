//
//  LevelInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 07/03/22.
//

import Foundation

protocol LevelInteracting {
    
    func startLevel()
    func completeLevel(timeRemaining: Double)
    
}

protocol LevelPresenting {

    func startLevel(with configuration: LevelConfiguration)
    func showEndScreen(for result: LevelEndStatus)
    
}

protocol LevelWorking {
    
    func getConfiguration(forLevel level: Int) -> LevelConfiguration
    func getStars(forLevel level: Int, timeRemaining: Double) -> Int
    
}
