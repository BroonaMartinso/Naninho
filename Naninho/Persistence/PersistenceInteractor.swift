//
//  PersistenceInteracting.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation

class PersistenceInteractor: PersistenceInteracting {
    enum UserDefaultKeys: String {
        case currLevel = "currentLevel"
        case maxLevel = "maxLevel"
        case completedLevels = "completedLevels"
    }
    
    private var worker: PersistenceWorking?

    init(worker: PersistenceWorking) {
        self.worker = worker
    }
    
    internal func saveCurrentLevel() {
        let currLevel = LevelHandler.shared.currentLevel
        worker?.persist(currLevel, atKey: UserDefaultKeys.currLevel.rawValue)
    }
    
    internal func saveMaxLevel() {
        let maxLevel = LevelHandler.shared.maxLevel
        worker?.persist(maxLevel, atKey: UserDefaultKeys.maxLevel.rawValue)
    }
    
    internal func saveCompletedLevels() {
        let completedLevels = LevelHandler.shared.completedLevels
        worker?.persist(completedLevels, atKey: UserDefaultKeys.completedLevels.rawValue)
    }
    
    func saveCurrentState() {
        saveCurrentLevel()
        saveMaxLevel()
        saveCompletedLevels()
    }
    
    func retrieveCurrentLevel() -> Int? {
        return worker?.retrieve(atKey: UserDefaultKeys.currLevel.rawValue)
    }
    
    func retrieveMaxLevel() -> Int? {
        return worker?.retrieve(atKey: UserDefaultKeys.maxLevel.rawValue)
    }
    
    func retrieveCompletedLevels() -> [Int:Int]? {
        return worker?.retrieve(atKey: UserDefaultKeys.completedLevels.rawValue)
    }
    
}
