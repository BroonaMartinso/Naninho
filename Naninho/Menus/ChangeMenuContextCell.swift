//
//  ChangeMenuContextCell.swift
//  Naninho
//
//  Created by Marco Zulian on 14/03/22.
//

import Foundation
import UIKit

class ChangeMenuContextCell: UICollectionViewCell {
    let label = UILabel()
    var delegate: ChangeContextDelegate?
    var status: MenuContext = .levels {
        didSet {
            configureLabel()
            if status == .levels {
                layer.borderColor = UIColor(named: "bege")?.cgColor
            } else {
                layer.borderColor = UIColor(named: "black")?.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "pink")
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "bege")?.cgColor
        
        setupLabel()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.textColor = UIColor (named: "bege")
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    func configureLabel() {
        label.text = status.rawValue
    }
    
    func select() {
        if let delegate = delegate {
            delegate.changeContext()
            status.change()
        }
    }
}

protocol ChangeContextDelegate {
    func changeContext()
}

enum MenuContext: String {
    case levels = "< skins"
    case skins = "< levels"
    
    mutating func change() {
        if self == .levels {
            self = .skins
        } else {
            self = .levels
        }
    }
}
