//
//  GetMoreTimePopup.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation
import UIKit
import AVFAudio

class GetMoreTimePopup: UIView, PopUp {
    
    private var messageLabel = UILabel()
    private var acceptButton: UIButton!
    private var declineButton = UIButton()
    weak var delegate: GetMoreTimePopupDelegate?
    
    override var bounds: CGRect {
        didSet {
            setupLevelLabel()
            setupDeclineButton()
            setupAcceptButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "verde")
        
        layer.cornerRadius = 25
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLevelLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate(
            [ messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
//              levelLabel.bottomAnchor.constraint(equalTo: centerYAnchor)
              messageLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20)
            ]
        )
        
        messageLabel.text = "Watch a short video to receive more 30s"
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor(named: "bege")
        messageLabel.font = .systemFont(ofSize: 18, weight: .light)
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
            delegate.dontPlayVideo()
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
            delegate.playVideo()
        }
    }
}

protocol GetMoreTimePopupDelegate: AnyObject {
    func playVideo()
    func dontPlayVideo()
}
