//
//  LevelMenuCell.swift
//  Naninho
//
//  Created by Marco Zulian on 10/02/22.
//

import Foundation
import UIKit

class LevelSelectionCell: UICollectionViewCell {
    
    let label = UILabel()
    let starImage = UIImageView()
    let levelLabel = UILabel ()
    var star : Int = 0 { didSet{ configureStarImage() } }
    var nivel : Int = 0 { didSet{ configureLabels() } }
    
    override var bounds: CGRect {
        didSet {
            setuplevelLabel()
            setupLabel()
            setupimage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "black")
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "bege")?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setuplevelLabel () {
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(levelLabel)
        levelLabel.text = "level"
        levelLabel.textColor = UIColor (named: "bege")
        levelLabel.leadingAnchor.constraint(equalTo : leadingAnchor, constant: 16).isActive = true
        levelLabel.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    func setupimage() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starImage)
        
        starImage.widthAnchor.constraint(equalToConstant: 0.42 * frame.width).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 0.18 * frame.height).isActive = true
        starImage.leadingAnchor.constraint(equalTo: levelLabel.leadingAnchor).isActive = true
        starImage.topAnchor.constraint(equalTo: levelLabel.bottomAnchor).isActive = true
    }
    
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        label.font = .systemFont(ofSize: 36)
        label.textColor = UIColor(named: "bege")
        label.numberOfLines = 1
        label.textAlignment = .center
       
        label.widthAnchor.constraint(equalToConstant: 0.45 * frame.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 99).isActive = true

        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        label.text = "1"
    
    }
    func configureLabels() {
        label.text = "\(nivel)"
    }
    
    func configureStarImage() {
        starImage.image = UIImage (named: "\(star)star")
    }
    
    func select() {
        backgroundColor = UIColor(named: "verde")
        label.textColor = UIColor(named: "bege")
        
        LevelHandler.shared.setLevel(to: nivel)
    }
    
    func deselect() {
        backgroundColor = UIColor(named: "black")
        label.textColor = UIColor(named: "bege")
    }
}
