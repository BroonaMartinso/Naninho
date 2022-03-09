//
//  BuySkinPopup.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation
import UIKit

class BuySkinPopup: PopUpView, PopUp {
    
    private var priceTag = PriceTagView()
    weak var delegate: BuySkinPopupDelegate?
    private var skin: Skin?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "verde")
        layer.cornerRadius = 25
        
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func declineButtonTapped() {
        if let delegate = delegate {
            delegate.dontBuySkin()
        }
    }
    
    @objc
    private func acceptButtonTappedWithCoins() {
        if let delegate = delegate,
            let skin = skin {
            delegate.buy(skin: skin)
        }
    }
    
    @objc
    private func acceptButtonTappedWithoutCoins() {
        if let delegate = delegate {
            delegate.showAdsForCoins()
        }
    }
    
    func configureForBuy(skin: Skin) {
        self.skin = skin
        configureTitle(with: "confirm purchase?", fontSize: 24)
        configureAcceptButton(with: "buy it!")
        priceTag.configureWith(price: skin.price, fontSize: 24, foregroundColor: UIColor(named: "bege"), backgroundColor: UIColor(named: "verde"))
        
        configureSubtitle(with: priceTag)
        backgroundColor = UIColor(named: "verde")
        acceptButton.removeTarget(nil, action: nil, for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTappedWithCoins), for: .touchUpInside)
    }
    
    func configureForNotEnoughCoins() {
        configureTitle(with: "Not enough credits!", fontSize: 24)
        configureAcceptButton(with: "watch a video for more!", fontSize: 18)

        backgroundColor = UIColor(named: "red")
        acceptButton.removeTarget(nil, action: nil, for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTappedWithoutCoins), for: .touchUpInside)
    }
}

protocol BuySkinPopupDelegate: AnyObject {
    func buy(skin: Skin)
    func dontBuySkin()
    func showAdsForCoins()
}

