//
//  LevelMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 09/02/22.
//

import Foundation
import UIKit

class LevelMenu: UIViewController {
    
    var levels: UICollectionView!
    var data: [Int: Int] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        levels.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = LevelHandler.shared.completedLevels
    }
    
    override func viewDidLoad() {
        data = LevelHandler.shared.completedLevels
    }
}

extension LevelMenu: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundColor = .red
        return cell
    }
}
