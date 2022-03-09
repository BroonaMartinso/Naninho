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
    
    var skin : Skin = Skin(imageName: "feliz") { didSet{ makeCell() } }
    
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
        if skin.isObtained {
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
        
        skinImage.image = UIImage(named: skin.imageName)
    }
    
    private func setupSkinImageWithButton() {
        skinImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(skinImage)
        
        NSLayoutConstraint.activate(
            [
                skinImage.widthAnchor.constraint(equalToConstant: 0.56 * frame.width),
                skinImage.heightAnchor.constraint(equalTo: skinImage.widthAnchor, multiplier: 1),
                skinImage.centerXAnchor.constraint(equalTo: centerXAnchor),
                skinImage.topAnchor.constraint(equalTo: topAnchor, constant: 10)
            ]
        )
        
        skinImage.image = UIImage(named: skin.imageName)
    }
    
    private func setupButton() {
        let image = UIImage(systemName: "nairasign.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 21))
        buyButton = ImageTextButton(label: "\(skin.price)",
                                    image: image,
                                    foregroundColor: UIColor(named: "black"),
                                    backgroundColor: UIColor(named: "bege"))
        
        addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [buyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
             buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)]
        )
    }
    
    func select() {
        backgroundColor = UIColor(named: "verde")
    }
    
    func deselect() {
        backgroundColor = UIColor(named: "bege")
    }
}
