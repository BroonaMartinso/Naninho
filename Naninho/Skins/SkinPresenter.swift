//
//  SkinPresenter.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation

class SkinPresenter: SkinPresenting {
    var popUp: BuySkinPopup
    private weak var viewController: SkinViewControlling?
    
    init(popUp: BuySkinPopup) {
        self.popUp = popUp
    }
    
    init(popUp: BuySkinPopup, vc: SkinViewControlling) {
        self.popUp = popUp
        self.viewController = vc
    }
    
    func presentBuyPopup(forSkin skin: Skin) {
        popUp.configureForBuy(skin: skin)
        viewController?.showPopup()
    }
    
    func presentGetCoinsPopup() {
        popUp.configureForNotEnoughCoins()
        viewController?.showPopup()
    }
    
    
}
