//
//  UserDefaultsWorker.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation

class UserDefaultsWorker: PersistenceWorking {
    
    func persist(_ value: Int, atKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func persist(_ value: [Int:Int], atKey key: String) {
        let encoder = PropertyListEncoder()
        
        if let data = try? encoder.encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func retrieve(atKey key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func retrieve(atKey key: String) -> [Int : Int]? {
        let decoder = PropertyListDecoder()
        
        if let data = UserDefaults.standard.data(forKey: key),
           let intDictionary = try? decoder.decode([Int : Int].self, from: data) {
                return intDictionary
        }
    
        return nil
        
    }
    
}
