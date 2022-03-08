//
//  RankingButton.swift
//  Naninho
//
//  Created by Marco Zulian on 05/03/22.
//

import UIKit

class ImageTextButton: UIButton {

    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    public init(label: String,
                image: UIImage?,
                imagePosition: NSDirectionalRectEdge = .leading,
                foregroundColor: UIColor?,
                backgroundColor: UIColor?) {
        super.init(frame: .zero)
        
        self.initialize(label: label,
                        image: image,
                        imagePosition: imagePosition,
                        foregroundColor: foregroundColor,
                        backgroundColor: backgroundColor)
    }
    
    open func initialize(label: String,
                         image: UIImage?,
                         imagePosition: NSDirectionalRectEdge = .leading,
                         foregroundColor: UIColor?,
                         backgroundColor: UIColor?) {
        self.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = foregroundColor
        configuration.baseBackgroundColor = backgroundColor
        configuration.attributedTitle = AttributedString(label, attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light),
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

}

