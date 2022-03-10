//
//  GameHeader.swift
//  Naninho
//
//  Created by Marco Zulian on 11/02/22.
//

import Foundation
import UIKit

class GameHeader: UIView {
    
    private var moneyButton: UIButton!
    private var rankingButton: UIButton!
    private var starButton: UIButton!
    private var buttonsContainer : UIView!
    private var rankingButtonContainer: UIView!
    var rankingInteractor: RankingInteracting?
    var delegate: GameHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupbox()
        setupMoneyButton()
        setupStarButton()
        setupRankingButtonContainer()
        setupranking()
        backgroundColor = UIColor (named: "black")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupbox(){
        buttonsContainer = UIView ()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsContainer)

        buttonsContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        buttonsContainer.heightAnchor.constraint(equalTo: buttonsContainer.widthAnchor, multiplier: 0.1).isActive = true
        buttonsContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
        
        buttonsContainer.backgroundColor =  UIColor(named: "black")
    }
    
    func setupMoneyButton() {
        let image = UIImage(systemName: "nairasign.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 21))
        moneyButton = ImageTextButton(label: "45",
                                      image: image,
                                      foregroundColor: UIColor(named: "bege"),
                                      backgroundColor: UIColor(named: "black"))
        
        buttonsContainer.addSubview(moneyButton)
        moneyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [moneyButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
             moneyButton.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)]
        )
        
        
        moneyButton.addTarget(self, action: #selector(moneyButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func moneyButtonTapped() {
        if let delegate = delegate {
            delegate.skins()
        }
    }
    
    func setupRankingButtonContainer() {
        rankingButtonContainer = UIView()
        buttonsContainer.addSubview(rankingButtonContainer)
        rankingButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rankingButtonContainer.leadingAnchor.constraint(equalTo: moneyButton.trailingAnchor),
            rankingButtonContainer.trailingAnchor.constraint(equalTo: starButton.leadingAnchor),
            rankingButtonContainer.heightAnchor.constraint(equalTo: buttonsContainer.heightAnchor),
            rankingButtonContainer.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)
        ])
        
    }
    
    func setupranking(){
        var image: UIImage?
        if #available(iOS 15, *) {
            image = UIImage(systemName: "list.bullet.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 21))
        } else {
            image = UIImage(systemName: "flag.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 21))
        }
        rankingButton = ImageTextButton(label: "ranking",
                                        image: image,
                                        imagePosition: .trailing,
                                        foregroundColor: UIColor(named: "bege"),
                                        backgroundColor: UIColor(named: "black"))
        

        rankingButtonContainer.addSubview(rankingButton)
        
        rankingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [rankingButton.centerXAnchor.constraint(equalTo: rankingButtonContainer.centerXAnchor),
             rankingButton.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)]
        )
        
        
        rankingButton.addTarget(self, action: #selector(rankingButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func rankingButtonTapped() {
        rankingInteractor?.handleRankingButtonTapped()
    }
    
    func setupStarButton() {
        // Setup label and image
        // TODO: ARRUMAR BOTAO DE ESTRELAS
        let label = "star 7 | 10"
        let image = UIImage(systemName: "star.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 21))
        
        // Init button
        starButton = ImageTextButton(label: label,
                                     image: image,
                                     foregroundColor: UIColor(named: "bege"),
                                     backgroundColor: UIColor(named: "black"))
        buttonsContainer.addSubview(starButton)
        
        // Constraints
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
             [starButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor),
             starButton.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)]
        )
        
        // Action
        starButton.addTarget(self, action: #selector(starsButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func starsButtonTapped() {
        rankingInteractor?.handleStarsButtonTapped()
    }
}

protocol GameHeaderDelegate {
    
    func skins()
    
}
