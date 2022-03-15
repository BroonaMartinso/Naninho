//
//  SkinsMenuDelegate.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation
import UIKit

class SkinsMenuDelegate: NSObject,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                         ChangeContextDelegate,
                         SkinSelectionDelegate {
    
    var skinInteractor: SkinInteracting?
    var delegate: SideMenuDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (skinInteractor?.skins.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeContext", for: indexPath) as! ChangeMenuContextCell
            cell.delegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinCell", for: indexPath) as! SkinSelectionCell
    
        if let skin = skinInteractor?.skins[indexPath.row - 1] {
            cell.skin = skin
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else {
            return CGSize(width: collectionView.frame.width, height: 155)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! ChangeMenuContextCell
            cell.select()
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SkinSelectionCell
        cell.select()
        
        skinInteractor?.select(cell.skin)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! SkinSelectionCell
            cell.deselect()
        }
    }
    
    func changeContext() {
        if let delegate = delegate {
            delegate.changeContextTo(.levels)
        }
    }
    
    func select(skin: Skin) {
        if let delegate = delegate {
            delegate.select(skin: skin)
        }
    }
    
}

protocol SideMenuDelegate {
    func changeContextTo(_ context: MenuContext)
    func handleLevelSelection(levelSelected: Int)
    func select(skin: Skin)
}
