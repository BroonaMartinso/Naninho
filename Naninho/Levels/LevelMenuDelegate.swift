//
//  LevelMenuDelegate.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation
import UIKit

class LevelMenuDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: LevelSelectionDelegate?
    var levelInteractor: LevelInteracting
    
    init(levelInteractor: LevelInteracting, delegate: LevelSelectionDelegate? = nil) {
        self.levelInteractor = levelInteractor
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(2, levelInteractor.maxLevel + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LevelSelectionCell
        let currLevel = max(1, levelInteractor.maxLevel) - indexPath.row
        
        cell.star = levelInteractor.getStarsFor(level: currLevel)
        cell.nivel = currLevel
        if currLevel != levelInteractor.currentLevel {
            cell.deselect()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width + 4, height:99)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.select()
        
        if let delegate = delegate {
            delegate.handleLevelSelection(levelSelected: cell.nivel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.deselect()
    }
}

protocol LevelSelectionDelegate {
    func handleLevelSelection(levelSelected: Int)
}