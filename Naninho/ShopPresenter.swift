//
//  ShopPresenter.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation

protocol ShopViewControlling: AnyObject {
    func openShop()
    func closeShop()
}

class ShopPresenter: ShopPresenting {
    
    weak var viewController: ShopViewControlling?
    
    func openShop() {
        viewController?.openShop()
    }
    
    func closeShop() {
        viewController?.closeShop()
    }
    
    
    
}
