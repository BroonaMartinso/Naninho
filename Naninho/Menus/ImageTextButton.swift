//
//  RankingButton.swift
//  Naninho
//
//  Created by Marco Zulian on 05/03/22.
//

import UIKit

class ImageTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override var bounds: CGRect {
        didSet {
            if #available(iOS 15, *) {} else { layer.cornerRadius = bounds.height / 2 }
        }
    }
    
    public init(label: String,
                font: UIFont = UIFont.systemFont(ofSize: 15, weight: .light),
                image: UIImage?,
                imagePosition: NSDirectionalRectEdge = .leading,
                foregroundColor: UIColor?,
                backgroundColor: UIColor?) {
        super.init(frame: .zero)
        
        self.initialize(label: label,
                        font: font,
                        image: image,
                        imagePosition: imagePosition,
                        foregroundColor: foregroundColor,
                        backgroundColor: backgroundColor)
    }
    
    open func initialize(label: String,
                         font: UIFont,
                         image: UIImage?,
                         imagePosition: NSDirectionalRectEdge = .leading,
                         foregroundColor: UIColor?,
                         backgroundColor: UIColor?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseForegroundColor = foregroundColor
            configuration.baseBackgroundColor = backgroundColor
            configuration.attributedTitle = AttributedString(label, attributes: AttributeContainer([
                NSAttributedString.Key.font: font,
            ]))
            configuration.image = image
            configuration.imagePlacement = imagePosition
            configuration.cornerStyle = .capsule
            configuration.background.strokeColor = foregroundColor
            configuration.background.strokeWidth = 1
            configuration.imagePadding = 10
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                                  leading: imagePosition == .leading ? 1 : 15,
                                                                  bottom: 5,
                                                                  trailing: imagePosition == .leading ? 15 : 1)
            
            self.configuration = configuration
            self.sizeToFit()
        }
        else {
            setTitle(label, for: .normal)
            if let foregroundColor = foregroundColor,
                let image = image
            {
                setImage(image.withTintColor(foregroundColor, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                setImage(image, for: .normal)
            }
            setTitleColor(foregroundColor, for: .normal)
            titleLabel?.font = font
            self.backgroundColor = backgroundColor
            layer.borderColor = foregroundColor?.cgColor
            layer.borderWidth = 1
            contentEdgeInsets = UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 15)
        }
    }
    
    open func changeLabel(to text: String, font: UIFont = UIFont.systemFont(ofSize: 15, weight: .light)) {
        
        if #available(iOS 15, *) {
            configuration?.attributedTitle = AttributedString(text, attributes: AttributeContainer([
                NSAttributedString.Key.font: font
            ]))
        } else {
            setTitle(text, for: .normal)
            titleLabel?.font = font
        }
    }

}

