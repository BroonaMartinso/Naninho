//
//  EndGameMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 13/02/22.
//

import Foundation
import UIKit

class EndGameMenu: UIViewController {
    
    override var prefersStatusBarHidden: Bool { true }
    
    private var messageLabel: UILabel!
    private var containerView: UIView!
    private var starsIndicator: UIImageView!
    private var firstButton: UIButton!
    private var secondButton: UIButton!
    private var thirdButton: UIButton!
    private var starImage: UIImageView!
    private var levelLabel: UILabel!
    private var status: EndGameStatus
    var delegate: EndGameMenuDelegate?
    private var level: Int
    private var stars: Int
    
    init(gameResult: EndGameStatus, level: Int, stars: Int?) {
        status = gameResult
        self.level = level
        if let stars = stars {
            self.stars = stars
        } else {
            self.stars = 0
        }
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        view.backgroundColor = UIColor(named: status == .win ? "verde" : "red")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupMessageLabel()
        setupContainerView()
        setupFirstButton()
        setupSecondButton()
        
        if level != 0 {
            setupStarImage()
        }
        setupLevelLabel()
        
        if status == .win {
            setupThirdButton()
        }
    }
    
    func setupMessageLabel() {
        messageLabel = UILabel()
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        messageLabel.text = status == .win ? "GOOD JOB!" : "MEH! FAIL"
        messageLabel.textColor = UIColor(named: "bege")
        let fontSize = getFontSize(forMessage: messageLabel.text!)
        messageLabel.font = .systemFont(ofSize: fontSize, weight: .bold)
        
        
        messageLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        messageLabel.sizeToFit()
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 10
    }
    
    func getFontSize(forMessage message: String) -> CGFloat {
        let possibleWidths: [CGFloat] = [144, 130, 122, 96, 84]
        var index = 0
        
        while index < possibleWidths.count {
            if message.width(withConstrainedHeight: 1000, font: .systemFont(ofSize: possibleWidths[index])) <= view.frame.height {
                return possibleWidths[index]
            }
            index += 1
        }
        
        return 80
    }
    
    func setupContainerView() {
        containerView = UIView()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupFirstButton() {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.baseForegroundColor = UIColor(named: status == .win ? "verde" : "red")
        configuration.baseBackgroundColor = UIColor(named: "bege")
        configuration.attributedTitle = AttributedString(status == .win ? "NEXT LEVEL" : "TRY AGAIN", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
        ]))
        configuration.cornerStyle = .capsule
        
        firstButton = UIButton(configuration: configuration, primaryAction: nil)
        
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstButton)
        
        NSLayoutConstraint.activate([
            firstButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            firstButton.heightAnchor.constraint(equalTo: firstButton.widthAnchor, multiplier: 0.25),
            firstButton.topAnchor.constraint(equalTo: containerView.centerYAnchor),
            firstButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)]
        )
        
        if status == .win {
            firstButton.addTarget(self, action: #selector(nextLevelButtonTapped), for: .touchUpInside)
        } else {
            firstButton.addTarget(self, action: #selector(replayButtonTapped), for: .touchUpInside)
        }
    }

    func setupSecondButton() {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.baseForegroundColor = UIColor(named: "bege")
        configuration.baseBackgroundColor = UIColor(named: status == .win ? "verde" : "red")
        configuration.attributedTitle = AttributedString(status == .win ? "MAKE BETTER" : "MENU", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
        ]))
        configuration.cornerStyle = .capsule
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = UIColor(named: "bege")
        
        secondButton = UIButton(configuration: configuration, primaryAction: nil)
        
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondButton)
        
        NSLayoutConstraint.activate([
            secondButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            secondButton.heightAnchor.constraint(equalTo: secondButton.widthAnchor, multiplier: 0.25),
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 15),
            secondButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)]
        )
        
        if status == .win {
            secondButton.addTarget(self, action: #selector(replayButtonTapped), for: .touchUpInside)
        } else {
            secondButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        }

    }
    
    func setupThirdButton() {
        var configuration = UIButton.Configuration.filled() // 1
        configuration.baseForegroundColor = UIColor(named: "bege")
        configuration.baseBackgroundColor = UIColor(named: "verde")
        configuration.attributedTitle = AttributedString("MENU", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
        ]))
        configuration.cornerStyle = .capsule
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = UIColor(named: "bege")
        
        thirdButton = UIButton(configuration: configuration, primaryAction: nil)
        
        thirdButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(thirdButton)
        
        NSLayoutConstraint.activate([
            thirdButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            thirdButton.heightAnchor.constraint(equalTo: thirdButton.widthAnchor, multiplier: 0.25),
            thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 15),
            thirdButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)]
        )
        
        thirdButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    func setupStarImage() {
        starImage = UIImageView(image: UIImage(named: "\(stars)star"))
        
        starImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(starImage)
        
        NSLayoutConstraint.activate(
            [
                starImage.bottomAnchor.constraint(equalTo: firstButton.topAnchor, constant: -30),
                starImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ]
        )
    }
    
    func setupLevelLabel() {
        levelLabel = UILabel()
        
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelLabel)
        
        levelLabel.text = level == 0 ? "TUTORIAL" : "LEVEL \(level)"
        levelLabel.textColor = UIColor(named: "bege")
        levelLabel.adjustsFontSizeToFitWidth = true
        levelLabel.minimumScaleFactor = 0.5
        levelLabel.font = .systemFont(ofSize: 36, weight: .regular)
        
        NSLayoutConstraint.activate(
            [
                levelLabel.bottomAnchor.constraint(equalTo: level == 0 ? firstButton.topAnchor : starImage.topAnchor, constant: -10),
                levelLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ]
        )
    }

    @objc
    func replayButtonTapped() {
        if status == .win {
            LevelHandler.shared.setLevel(to: LevelHandler.shared.currentLevel - 1)
        }
        
        if let delegate = delegate {
            delegate.replayLevel()
        }
        dismiss(animated: true)
    }
    
    @objc
    func nextLevelButtonTapped() {
        if let delegate = delegate {
            delegate.goToNextLevel()
        }
        dismiss(animated: true)
    }
    
    @objc
    func menuButtonTapped() {
        if let delegate = delegate {
            delegate.goToMenu()
        }
        dismiss(animated: true)
    }
    
}

enum EndGameStatus {
    case win
    case lose
}

protocol EndGameMenuDelegate {
    func replayLevel()
    func goToNextLevel()
    func goToMenu()
}
