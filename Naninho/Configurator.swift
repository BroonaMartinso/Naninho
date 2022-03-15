//
//  Configurator.swift
//  Naninho
//
//  Created by Marco Zulian on 12/03/22.
//

import UIKit
import GameKit

class Configurator {
    
//    static func configure(_ vc: GameViewController) -> GameViewController {
//        
//        let header = addHeader(to: vc)
//        let bouncyCharView = addBouncyCharView(to: vc)
//        
//        let rankingPresenter = RankingPresenter(viewController: vc)
//        let rankingWorker = RankingWorker()
//        let rankingInteractor = RankingInteractor(presenter: rankingPresenter, worker: rankingWorker)
//        header.rankingInteractor = rankingInteractor
//        header.delegate = vc
//        
//        let adsPresenter = AdsPresenter(viewController: vc)
//        let adsWorker = AdsWorker()
//        let adsInteractor = BannerAndInterstitialAdsInteractor(presenter: adsPresenter, worker: adsWorker)
//        let adsRouter = AdsRouter(vc: vc)
//        
//        let rewardedAdsInteractor = RewardedAdsInteractor(presenter: adsPresenter, worker: adsWorker)
//        
//        let skinsDelegate = SkinsMenuDelegate()
//        let levelDelegate = LevelMenuDelegate(levelInteractor: levelInteractor!)
//        levelDelegate.delegate = vc
//    }
//    
//    private static func addHeader(to vc: GameViewController) -> GameHeader {
//        let header = GameHeader()
//        
//        header.translatesAutoresizingMaskIntoConstraints = false
//        vc.view.addSubview(header)
//        
//        let animatableHeaderConstraint = header.topAnchor.constraint(equalTo: vc.view.topAnchor)
//        
//        NSLayoutConstraint.activate([
//            animatableHeaderConstraint,
//            header.heightAnchor.constraint(equalToConstant: vc.view.frame.height * 0.13),
//            header.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
//            header.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor)
//        ])
//        
//        return header
//    }
//    
//    private static func addBouncyCharView(to vc: GameViewController) -> SKView {
//        let bouncyCharView = SKView()
//        
//        bouncyCharView.translatesAutoresizingMaskIntoConstraints = false
//        vc.view.addSubview(bouncyCharView)
//        
//        let animatableGameSceneConstraint = bouncyCharView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: vc.view.frame.width * 0.375 / 2)
//        
//        NSLayoutConstraint.activate([
//            bouncyCharView.topAnchor.constraint(equalTo: vc.header.bottomAnchor),
//            bouncyCharView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
////            bouncyCharView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            bouncyCharView.widthAnchor.constraint(equalTo: vc.view.widthAnchor),
//            animatableGameSceneConstraint
//        ])
//        
//        let aspectRatio = (vc.view.frame.height / vc.view.frame.width)
//        if let scene = SKScene(fileNamed: aspectRatio > 2 ? "BouncyBall" : "GameScene") as? BouncyBallScene {
//            scene.scaleMode = .aspectFill
//            scene.backgroundColor = UIColor(named: "bege")!
//            scene.del = vc
//            scene.router = vc.rewardAdPopUpRouter
//            
//            bouncyCharView.presentScene(scene)
//        }
//        
//        let scene = bouncyCharView.scene as! BouncyBallScene
//        scene.gameViewController = vc
//        let levelInteractor = LevelInteractor(worker: LevelWorker(), presenter: scene)
//        
//        return bouncyCharView
//    }
//    
}
