//
//  SkinProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation

protocol SkinInteracting {
    var skins: [Skin] { get }
    func buy(skin: Skin)
    func select(_ skin: Skin)
}

protocol SkinPresenting {
    var popUp: BuySkinPopup { get }
    func presentBuyPopup(forSkin skin: Skin)
    func presentGetCoinsPopup()
}

protocol SkinViewControlling: AnyObject {
    func showPopup()
}
