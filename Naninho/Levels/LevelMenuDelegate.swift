//
//  LevelMenuDelegate.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation
import UIKit

class LevelMenuDelegate: NSObject,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                         ChangeContextDelegate {
    
    var beginLevelPopUpsRouter: PopUpRouting?
    var levelInteractor: LevelInteracting
    var delegate: SideMenuDelegate?
    
    init(levelInteractor: LevelInteracting, delegate: SideMenuDelegate? = nil) {
        self.levelInteractor = levelInteractor
        self.delegate = delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(3, levelInteractor.maxLevel + 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeContext", for: indexPath) as! ChangeMenuContextCell
            cell.status = .levels
            cell.delegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LevelSelectionCell
        let currLevel = max(1, levelInteractor.maxLevel) - indexPath.row + 1
        
        cell.star = levelInteractor.getStarsFor(level: currLevel)
        cell.nivel = currLevel
        if currLevel != levelInteractor.currentLevel {
            cell.deselect()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width + 4, height:50)
        } else {
            return CGSize(width: collectionView.frame.width + 4, height:99)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! ChangeMenuContextCell
            cell.select()
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.select()
        
        levelInteractor.setLevel(to: cell.nivel)
        beginLevelPopUpsRouter?.show()
        
//        if let delegate = delegate {
//            delegate.handleLevelSelection(levelSelected: cell.nivel)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.deselect()
    }
    
    func changeContext() {
        if let delegate = delegate {
            delegate.changeContextTo(.skins)
        }
    }
}
