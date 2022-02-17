//
//  GameHeader.swift
//  Naninho
//
//  Created by Marco Zulian on 11/02/22.
//

import Foundation
import UIKit

class GameHeader: UIView {
    
    private var rankingButton: UIButton!
    private var starButton: UIButton!
    private var buttonsContainer : UIView!
    var delegate: GameHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupbox()
        setupranking()
        setupStarButton()
        backgroundColor = UIColor (named: "black")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupbox(){
        buttonsContainer = UIView ()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsContainer)

        buttonsContainer.heightAnchor.constraint(equalToConstant: max(39, 0.312 *  frame.height)).isActive = true
        buttonsContainer.widthAnchor.constraint(equalTo: buttonsContainer.heightAnchor, multiplier: 8.07).isActive = true
        buttonsContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
        
        buttonsContainer.backgroundColor =  UIColor(named: "black")
    }
    
    func setupranking(){
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = UIColor(named: "bege")
        configuration.baseBackgroundColor = UIColor(named: "black")
        configuration.attributedTitle = AttributedString("ranking", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light),
        ]))
        configuration.image = UIImage(systemName: "chart.bar.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        configuration.imagePlacement = .trailing
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = UIColor(named: "bege")
        configuration.background.strokeWidth = 1
        configuration.imagePadding = 10
        
        rankingButton = UIButton(configuration: configuration, primaryAction: nil)
        
        buttonsContainer.addSubview(rankingButton)
        rankingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [rankingButton.heightAnchor.constraint(equalTo: buttonsContainer.heightAnchor),
             rankingButton.widthAnchor.constraint(equalTo: rankingButton.heightAnchor, multiplier: 3.28),
             rankingButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
             rankingButton.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)]
        )
        
        
        rankingButton.addTarget(self, action: #selector(rankingButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func rankingButtonTapped() {
        if let delegate = delegate {
            delegate.handleRankingButtonTapped()
        }
    }
    
    func setupStarButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = UIColor(named: "bege")
        configuration.baseBackgroundColor = UIColor(named: "black")
        configuration.attributedTitle = AttributedString("star \(LevelHandler.shared.obtainedStars) | \(LevelHandler.shared.maxAchieavableStars)", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light),
        ]))
        configuration.image = UIImage(systemName: "star.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        configuration.imagePlacement = .leading
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = UIColor(named: "bege")
        configuration.background.strokeWidth = 1
        configuration.imagePadding = 10
        
        starButton = UIButton(configuration: configuration, primaryAction: nil)
        
        buttonsContainer.addSubview(starButton)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [starButton.heightAnchor.constraint(equalTo: buttonsContainer.heightAnchor),
             starButton.widthAnchor.constraint(equalTo: starButton.heightAnchor, multiplier: 4.56),
             starButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor),
             starButton.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)]
        )
        
        starButton.addTarget(self, action: #selector(starsButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func starsButtonTapped() {
        if let delegate = delegate {
            delegate.handleRankingButtonTapped()
        }
    }
}

protocol GameHeaderDelegate {
    func handleRankingButtonTapped()
    func handleStarsButtonTapped()
}
