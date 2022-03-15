//
//  User.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation

class User: SkinInteracting {
    
    private(set) var coins: Int = 1500
    private(set) var skins: [Skin] = SkinRepository.skins
    private(set) var selectedSkin: Skin = Skin(imageName: "feliz", isObtained: true) {
        didSet {
            for listener in listeners {
                listener.handleChangeTo(skin: selectedSkin)
            }
        }
    }
    var skinPresenter: SkinPresenting?
    private var listeners: [SkinChangeListener] = []
    
    func buy(skin: Skin) {
        if coins >= skin.price {
            skins.first { $0.imageName == skin.imageName }?.isObtained = true
            coins -= skin.price
        }
    }
    
    func select(_ skin: Skin) {
        if skin.isObtained {
            selectedSkin = skin
        } else if coins >= skin.price {
            skinPresenter?.presentBuyPopup(forSkin: skin)
        } else {
            skinPresenter?.presentGetCoinsPopup()
        }
    }
    
    func getCoins(_ value: Int) {
        coins += value
    }
    
    func addListener(_ listener: SkinChangeListener) {
        listeners.append(listener)
    }
}

protocol SkinChangeListener {
    func handleChangeTo(skin: Skin)
}
