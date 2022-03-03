//
//  PopUpFactory.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation
import UIKit

class PopUpFactory {
    
    func makeLevelBeginPopUp(forLevel level: Int, andStars stars: Int) {
        let view = UIView()
        addLevelLabelAndStars(inView: view, forLevel: level, andStars: stars)
        addAcceptButton(inView: view, action: #selector(acceptButtonTapped))
        
    }
    
    @objc
    func acceptButtonTapped() {}
    
    private func addLevelLabelAndStars(inView view: UIView, forLevel level: Int, andStars stars: Int) {
        let levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelLabel)
        
        NSLayoutConstraint.activate(
            [ levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              levelLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
              levelLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
            ]
        )
        
        levelLabel.text = "LEVEL \(level)"
        levelLabel.textAlignment = .center
        levelLabel.textColor = UIColor(named: "bege")
        levelLabel.font = .systemFont(ofSize: 36, weight: .light)
        
        let starsImage = UIImageView()
        starsImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starsImage)
        
        NSLayoutConstraint.activate(
            [ starsImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
              starsImage.heightAnchor.constraint(equalTo: starsImage.widthAnchor, multiplier: 0.25),
              starsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              starsImage.topAnchor.constraint(equalTo: levelLabel.bottomAnchor)
            ]
        )
        
        starsImage.image = UIImage(named: "\(stars)star")
    }
    
    private func addAcceptButton(inView view: UIView, action: Selector) {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.baseForegroundColor = UIColor(named: "bege")
        configuration.baseBackgroundColor = UIColor(named: "black")
        configuration.attributedTitle = AttributedString("let's goooo!", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .light),
        ]))
        configuration.background.cornerRadius = 0
        
        let acceptButton = UIButton(configuration: configuration, primaryAction: nil)
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(acceptButton)
        
        NSLayoutConstraint.activate(
            [ acceptButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.34),
              acceptButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.63),
              acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              acceptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
        
        acceptButton.layer.cornerRadius = 25
        acceptButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        acceptButton.clipsToBounds = true
        acceptButton.titleLabel?.numberOfLines = 1
        acceptButton.titleLabel?.adjustsFontSizeToFitWidth = true
        acceptButton.titleLabel?.minimumScaleFactor = 0.6
        
        acceptButton.addTarget(self, action: action, for: .touchUpInside)
    }
}
