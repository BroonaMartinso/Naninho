//
//  PopUp.swift
//  Naninho
//
//  Created by Marco Zulian on 09/03/22.
//

import Foundation
import UIKit

class PopUpView: UIView {
    
    private var title = UILabel()
    private var subtitle = UIView()
    open var acceptButton = UIButton()
    open var declineButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "verde")
        layer.cornerRadius = 25
        
        setupTitleLabel()
        setupDeclineButton()
        setupAcceptButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        NSLayoutConstraint.activate(
            [ title.centerXAnchor.constraint(equalTo: centerXAnchor),
              title.widthAnchor.constraint(equalTo: widthAnchor),
              title.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20)
            ]
        )
        
        title.textAlignment = .center
        title.numberOfLines = 0
        title.textColor = UIColor(named: "bege")
    }
    
    func setupSubtitle() {
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitle)
        
        NSLayoutConstraint.activate(
            [
              subtitle.centerXAnchor.constraint(equalTo: centerXAnchor),
              subtitle.topAnchor.constraint(equalTo: title.bottomAnchor)
            ]
        )
    }
    
    func setupDeclineButton() {
        let buttonImage = UIImage(systemName: "xmark.circle.fill",
                                  withConfiguration: UIImage.SymbolConfiguration(scale: .large))

        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseForegroundColor = UIColor(named: "black")
            configuration.baseBackgroundColor = UIColor(named: "bege")
            configuration.image = buttonImage
            configuration.background.cornerRadius = 0
            declineButton = UIButton(configuration: configuration, primaryAction: nil)
        } else {
            declineButton = UIButton()
            declineButton.setImage(buttonImage!.withTintColor(UIColor(named: "black")!, renderingMode: .alwaysOriginal), for: .normal)
            declineButton.backgroundColor = UIColor(named: "bege")
        }
        
        
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
    }
    
    func setupAcceptButton() {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseForegroundColor = UIColor(named: "bege")
            configuration.baseBackgroundColor = UIColor(named: "black")
            configuration.background.cornerRadius = 0
            acceptButton = UIButton(configuration: configuration, primaryAction: nil)
        } else {
            acceptButton = UIButton()
            acceptButton.backgroundColor = UIColor(named: "black")
            acceptButton.titleLabel?.textColor = UIColor(named: "bege")
        }
        
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
    }
    
    func configureTitle(with title: String, fontSize: CGFloat = 36) {
        self.title.text = title
        self.title.font = .systemFont(ofSize: fontSize, weight: .light)
    }
    
    func configureSubtitle(with view: UIView) {
        subtitle = view
        setupSubtitle()
    }
    
    func configureAcceptButton(with text: String, fontSize: CGFloat = 24) {
        if #available(iOS 15, *) {
            let acceptButtonText = AttributedString(text, attributes: AttributeContainer([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .light),
            ]))
            acceptButton.configuration?.attributedTitle = acceptButtonText
        } else {
            let acceptButtonText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .light)])
            acceptButton.setAttributedTitle(acceptButtonText, for: .normal)
        }
        
    }
}
