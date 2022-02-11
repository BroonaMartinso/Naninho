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
    var exitButtom: UIButton!
    var data: [Int: Int] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = LevelHandler.shared.completedLevels
        print (data)
        view.backgroundColor = .clear
        setupLevels()
        setupExitButtom()
    }
    
    override func viewDidLoad() {
        data = LevelHandler.shared.completedLevels
        view.backgroundColor = .clear
        setupLevels()
        setupExitButtom()
    }
    
    private func setupLevels() {
        // Layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumInteritemSpacing = view.frame.width * 0.1
        layout.minimumLineSpacing = layout.minimumInteritemSpacing * 0.7
        layout.sectionInset = UIEdgeInsets(top: 0, left: view.frame.width * 0.1, bottom: 0, right: view.frame.width * 0.1)
        layout.scrollDirection = .vertical
        
        levels = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
//        levels.allowsSelection = false
//        levels.isScrollEnabled = false
        
        levels.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levels)
        
        levels.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        levels.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        levels.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        levels.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        levels.register(LevelMenuCell.self, forCellWithReuseIdentifier: "Cell")
//        impactCount.register(ImpactHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        levels.dataSource = self
        levels.delegate = self
        
        levels.backgroundColor = UIColor(named: "bege")
    }
    
    func setupExitButtom() {
        let exitButtom = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        exitButtom.backgroundColor = .green
        exitButtom.setTitle("Test Button", for: .normal)
        exitButtom.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
//        exitButtom.translatesAutoresizingMaskIntoConstraints = false
//        exitButtom.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        exitButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0.1*view.frame.width).isActive = true
//        levels.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        levels.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(exitButtom)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true)
    }
}

extension LevelMenu: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = levels.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LevelMenuCell
        cell.setupLabels(withText: indexPath.row + 1 )
//        cell.backgroundColor = .red
        cell.star = data[indexPath.row + 1]!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.2, height: view.frame.width * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? LevelMenuCell
        cell?.select()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? LevelMenuCell
        cell?.unselect() // <----- this can be null here, and the cell can still come back on screen!
    }
}
