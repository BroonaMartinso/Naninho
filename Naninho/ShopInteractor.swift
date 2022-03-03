//
//  ShopInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation

protocol ShopPresenting: AnyObject {
    
    func openShop()
    func closeShop()
    
}

class ShopInteractor: MainSceneShopInteractor {
    
    var presenter: ShopPresenting?
    
    func openShop() {
        presenter?.openShop()
    }
    
    func closeShop() {
        presenter?.closeShop()
    }
    
}
