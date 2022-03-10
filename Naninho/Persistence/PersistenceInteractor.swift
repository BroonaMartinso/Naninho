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
    
    internal func save(currentLevel: Int) {
        worker?.persist(currentLevel, atKey: UserDefaultKeys.currLevel.rawValue)
    }
    
    internal func save(maxLevel: Int) {
        worker?.persist(maxLevel, atKey: UserDefaultKeys.maxLevel.rawValue)
    }
    
    internal func save(completedLevels: [Int:Int]) {
        worker?.persist(completedLevels, atKey: UserDefaultKeys.completedLevels.rawValue)
    }
    
    func saveCurrentState(currentLevel: Int,
                          maxLevel: Int,
                          completedLevels: [Int:Int]) {
        save(currentLevel: currentLevel)
        save(maxLevel: maxLevel)
        save(completedLevels: completedLevels)
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
