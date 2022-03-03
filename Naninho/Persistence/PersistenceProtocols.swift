//
//  PersistenceProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation

protocol PersistenceWorking {
    func persist(_ value: Int, atKey key: String)
    func persist(_ value: [Int:Int], atKey key: String)
    func retrieve(atKey key: String) -> Int?
    func retrieve(atKey key: String) -> [Int: Int]?
}

protocol PersistenceInteracting {
    func saveCurrentLevel()
    func saveMaxLevel()
    func saveCompletedLevels()
    func saveCurrentState()
    func retrieveCurrentLevel() -> Int?
    func retrieveMaxLevel() -> Int?
    func retrieveCompletedLevels() -> [Int:Int]?
}
