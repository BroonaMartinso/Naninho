//
//  BeginLevelPopup.swift
//  Naninho
//
//  Created by Marco Zulian on 12/02/22.
//

import Foundation
import UIKit
import AVFAudio

class BeginLevelPopup: UIView, LevelChangeListener {
    
    private var levelLabel = UILabel()
    private var starsImage = UIImageView()
    private var acceptButton: UIButton!
    private var declineButton = UIButton()
    var delegate: BeginLevelPopupDelegate?
    
    private var level: Int = 0 {
        didSet {
            configureLevelLabel()
        }
    }
    
    private var stars: Int = 0 {
        didSet {
            configureStars()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setupLevelLabel()
            setupStarsImage()
            setupDeclineButton()
            setupAcceptButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "verde")
        
        layer.cornerRadius = 25
        
        LevelHandler.shared.addListener(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLevelLabel() {
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(levelLabel)
        
        NSLayoutConstraint.activate(
            [ levelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              levelLabel.widthAnchor.constraint(equalTo: widthAnchor),
//              levelLabel.bottomAnchor.constraint(equalTo: centerYAnchor)
              levelLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20)
            ]
        )
        
//        levelLabel.text = "LEVEL ?"
        levelLabel.textAlignment = .center
        levelLabel.textColor = UIColor(named: "bege")
        levelLabel.font = .systemFont(ofSize: 36, weight: .light)
    }
    
    func setupStarsImage() {
        starsImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starsImage)
        
        NSLayoutConstraint.activate(
            [ starsImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
              starsImage.heightAnchor.constraint(equalTo: starsImage.widthAnchor, multiplier: 0.25),
              starsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
              starsImage.topAnchor.constraint(equalTo: levelLabel.bottomAnchor)
            ]
        )
        
//        starsImage.image = UIImage(named: "1star")
    }
    
    func setupDeclineButton() {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.baseForegroundColor = UIColor(named: "black")
        configuration.baseBackgroundColor = UIColor(named: "bege")
        configuration.image = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        configuration.background.cornerRadius = 0
        
        declineButton = UIButton(configuration: configuration, primaryAction: nil)
        
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(declineButton)
        
        NSLayoutConstraint.activate(
            [ declineButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.34),
              declineButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.37),
              declineButton.leadingAnchor.constraint(equalTo: leadingAnchor),
              declineButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        
        declineButton.layer.cornerRadius = 25
        declineButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        declineButton.clipsToBounds = true
        
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func declineButtonTapped() {
        if let delegate = delegate {
            delegate.handleDenial()
        }
    }
    
    func setupAcceptButton() {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.baseForegroundColor = UIColor(named: "bege")
        configuration.baseBackgroundColor = UIColor(named: "black")
        configuration.attributedTitle = AttributedString("let's goooo!", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .light),
        ]))
        configuration.background.cornerRadius = 0
        
        acceptButton = UIButton(configuration: configuration, primaryAction: nil)
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(acceptButton)
        
        NSLayoutConstraint.activate(
            [ acceptButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.34),
              acceptButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.63),
              acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor),
              acceptButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        
        acceptButton.layer.cornerRadius = 25
        acceptButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        acceptButton.clipsToBounds = true
        acceptButton.titleLabel?.numberOfLines = 1
        acceptButton.titleLabel?.adjustsFontSizeToFitWidth = true
        acceptButton.titleLabel?.minimumScaleFactor = 0.6
        
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func acceptButtonTapped() {
        if let delegate = delegate {
            delegate.handleAcceptance()
        }
    }
    
    func configureLevelLabel() {
        if level == 0 {
            levelLabel.text = "TUTORIAL"
        } else {
            levelLabel.text = "LEVEL \(level)"
        }
    }
    
    func configureStars() {
        starsImage.image = UIImage(named: "\(stars)star")
    }
    
    func handleLevelChange(to newLevel: Int) {
        level = newLevel
        
        if let stars = LevelHandler.shared.completedLevels[newLevel] {
            self.stars = stars
        } else {
            stars = 0
        }
    }
}

protocol BeginLevelPopupDelegate {
    func handleAcceptance()
    func handleDenial()
}
