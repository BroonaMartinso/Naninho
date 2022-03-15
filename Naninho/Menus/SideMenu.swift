//
//  SideMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 12/03/22.
//

import Foundation
import UIKit

class SideMenu: UIView {
    
    private var menu: UICollectionView!
    
    private var levelPopup: BeginLevelPopup!
    private var beginLevelPopUpsRouter: PopUpRouting?
    private var buySkinPopup: BuySkinPopup!
    private var buySkinPopupRouter: PopUpRouting?
    private var skinsDelegate: SkinsMenuDelegate!
    private var levelDelegate: LevelMenuDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMenu()
        
        backgroundColor = UIColor (named: "black")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMenu() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: -2)
        
        menu = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        
        menu.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menu)
        
        let animatableLevelSelectionMenuConstraint = menu.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: topAnchor),
            animatableLevelSelectionMenuConstraint,
            menu.bottomAnchor.constraint(equalTo: bottomAnchor),
            menu.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        menu.showsVerticalScrollIndicator = false
        menu.register(LevelSelectionCell.self, forCellWithReuseIdentifier: "Cell")
        menu.register(SkinSelectionCell.self, forCellWithReuseIdentifier: "SkinCell")
        menu.allowsSelection = true
        menu.backgroundColor = UIColor(named: "black")
        
        menu.delegate = levelDelegate
        menu.dataSource = levelDelegate
    }
}
