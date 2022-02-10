//
//  LevelMenuCell.swift
//  Naninho
//
//  Created by Marco Zulian on 10/02/22.
//

import Foundation
import UIKit

class LevelMenuCell: UICollectionViewCell {

    let label = UILabel()
    let bgImage = UIImageView()

    override var bounds: CGRect {
        didSet {
            setupBgImage()
            setupLabel()
//            backgroundColor = .blue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "bege")
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        label.font = .systemFont(ofSize: 33)
        label.textColor = UIColor(named: "black")
        label.numberOfLines = 1
        label.textAlignment = .center

        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
    }
    
    func setupBgImage() {
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bgImage)
        
        if !self.isSelected {
            bgImage.image = UIImage(named: "inicial")
        }
        
        bgImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bgImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        bgImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bgImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }

    func setupLabels(withText text: Int) {
        label.text = "\(text)"
    }
    
    func select() {
        backgroundColor = UIColor(named: "black")
        label.textColor = UIColor(named: "bege")
    }
    
    func unselect() {
        backgroundColor = UIColor(named: "bege")
        label.textColor = UIColor(named: "black")
    }
}
