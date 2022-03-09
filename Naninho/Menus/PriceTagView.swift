//
//  PriceView.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation
import UIKit

class PriceTagView: UIView {
    
    private var coinImage: UIImageView!
    private var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCoinImage()
        setupPriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoinImage() {
        coinImage = UIImageView()
        coinImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(coinImage)
        
        NSLayoutConstraint.activate([
            coinImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            coinImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupPriceLabel() {
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: coinImage.trailingAnchor, constant: 3),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureWith(price: Int,
                       fontSize: CGFloat,
                       foregroundColor: UIColor?,
                       backgroundColor: UIColor?) {
        coinImage.image = UIImage(systemName: "nairasign.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize))
        
        priceLabel.text = "\(price)"
        priceLabel.textColor = foregroundColor
        priceLabel.font = UIFont.systemFont(ofSize: fontSize)
        
        self.backgroundColor = backgroundColor
    }
}
