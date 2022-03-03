//
//  PopUpsInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation

class PopUpInteractor {
    
    private var presenter: PopUpPresenting?
    
    
    func showBeginLevelPopup() {
        let level = LevelHandler.shared.currentLevel
        let stars = LevelHandler.shared.getStarsFor(level: level)
        
        presenter?.preparePopUp(forLevel: level, andStars: stars)
    }
    
    func showMoreTimePopup() {
        
    }
    
}
