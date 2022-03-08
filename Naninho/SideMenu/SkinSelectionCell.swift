//
//  SkinSelectionCell.swift
//  Naninho
//
//  Created by Marco Zulian on 05/03/22.
//

import Foundation
import UIKit

class SkinSelectionCell: UICollectionViewCell {
    
    let skinImage = UIImageView()
    var buyButton: UIButton!
    
    var skin : String = "feliz" { didSet{ makeCell() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "bege")
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "black")?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeCell() {
        //TODO: If skin.isPurchased
        if true {
            setupSkinImageWithoutButton()
        } else {
            setupSkinImageWithButton()
            setupButton()
        }
    }
    
    private func setupSkinImageWithoutButton() {
        skinImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(skinImage)
        
        NSLayoutConstraint.activate(
            [
                skinImage.widthAnchor.constraint(equalToConstant: 0.66 * frame.width),
                skinImage.heightAnchor.constraint(equalTo: skinImage.widthAnchor, multiplier: 1),
                skinImage.centerXAnchor.constraint(equalTo: centerXAnchor),
                skinImage.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
    }
    
    private func setupSkinImageWithButton() {
        skinImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(skinImage)
        
        NSLayoutConstraint.activate(
            [
                skinImage.widthAnchor.constraint(equalToConstant: 0.66 * frame.width),
                skinImage.heightAnchor.constraint(equalTo: skinImage.widthAnchor, multiplier: 1),
                skinImage.centerXAnchor.constraint(equalTo: centerXAnchor),
                skinImage.topAnchor.constraint(equalTo: topAnchor, constant: 10)
            ]
        )
    }
    
    private func setupButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = UIColor(named: "black")
        configuration.baseBackgroundColor = UIColor(named: "bege")
        //TODO: skin.price
        configuration.attributedTitle = AttributedString("45", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light),
        ]))
        //TODO: skin.image
        configuration.image = UIImage(named: "coin")
        configuration.imagePlacement = .leading
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = UIColor(named: "black")
        configuration.background.strokeWidth = 1
        configuration.imagePadding = 10
        
        buyButton = UIButton(configuration: configuration, primaryAction: nil)
        
        addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [buyButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
             buyButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
             buyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
             buyButton.topAnchor.constraint(equalTo: skinImage.bottomAnchor, constant: 10)]
        )
        
        
//        rankingButton.addTarget(self, action: #selector(rankingButtonTapped), for: .touchUpInside)
    }
}
