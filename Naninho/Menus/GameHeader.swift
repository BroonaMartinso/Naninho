//
//  GameHeader.swift
//  Naninho
//
//  Created by Marco Zulian on 11/02/22.
//

import Foundation
import UIKit

class GameHeader: UIView {
    
    private var ranking: UIButton!
    private var star: UIButton!
    var box : UIView!
    
    func setupbox(){
        box = UIView ()
        box.translatesAutoresizingMaskIntoConstraints = false
        addSubview(box)

        box.widthAnchor.constraint(equalToConstant: 0.77 * frame.width).isActive = true
        box.heightAnchor.constraint(equalToConstant: 0.312 * frame.height).isActive = true
        box.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        box.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        box.backgroundColor =  UIColor(named: "bege")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupbox()
        backgroundColor = UIColor (named: "black")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupranking(){
        ranking = UIButton()
        
        addSubview(ranking)
        ranking.translatesAutoresizingMaskIntoConstraints = false
        
        ranking.widthAnchor.constraint(equalToConstant: 128).isActive = true
        ranking.heightAnchor.constraint(equalToConstant: 39).isActive = true
                
    }
}
