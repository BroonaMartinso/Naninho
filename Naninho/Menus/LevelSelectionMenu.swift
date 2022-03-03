//
//  LevelSelectionMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import UIKit

class LevelSelectionMenu: UIViewController {
    
    private var menu: UICollectionView!
//    var presenter: SideBarPresenting?
    
    override func viewDidLoad() {
        setupLevelSelectionMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menu.reloadData()
        menu.indexPathsForSelectedItems?.forEach { menu.deselectItem(at: $0, animated: false) }
    }
    
    func setupLevelSelectionMenu() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        menu = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        
        menu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menu)
        
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: view.topAnchor),
            menu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menu.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        menu.showsVerticalScrollIndicator = false
        menu.register(LevelSelectionCell.self, forCellWithReuseIdentifier: "Cell")
        menu.allowsSelection = true
        menu.backgroundColor = UIColor(named: "black")
        
        menu.delegate = self
        menu.dataSource = self
    }
}

extension LevelSelectionMenu: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(2, LevelHandler.shared.maxLevel + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menu.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LevelSelectionCell
        let currLevel = max(1, LevelHandler.shared.maxLevel) - indexPath.row
        
        if let data = LevelHandler.shared.getStarsFor(level: currLevel) {
            cell.star = data
        } else {
            cell.star = 0
        }
        
        cell.nivel = currLevel
        if currLevel != LevelHandler.shared.currentLevel {
            cell.deselect()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: menu.frame.width + 4, height:99)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = menu.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.select()
        
//        UIView.animate(withDuration: 0.3, delay: 0) {
//            self.animatablePopupConstraint.constant = 0
//            self.view.layoutIfNeeded()
//        }
//
//        disableBackgroundInteractions()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = menu.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.deselect()
    }
    
}

