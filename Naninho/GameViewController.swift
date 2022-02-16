//
//  GameViewController.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController {
  
    enum DisplayStatus {
        case menu
        case game
    }
    
    var bannerView: GADBannerView!
    private var levelsWon: Int = 0
    private var interstitial: GADInterstitialAd?
    private var header: GameHeader!
    private var levelSelectionMenu: UICollectionView!
    private var bouncyCharView: SKView!
    private var levelPopup: BeginLevelPopup!
    private var animatableLevelSelectionMenuConstraint: NSLayoutConstraint!
    private var animatableHeaderConstraint: NSLayoutConstraint!
    private var animatablePopupConstraint: NSLayoutConstraint!
    private var displayStatus: GameViewController.DisplayStatus = .menu {
        didSet {
            if displayStatus == .game {
                self.disableBackgroundInteractions()
                bannerView.alpha = 0
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.animatableLevelSelectionMenuConstraint.constant = -self.view.frame.width * 0.375
                    self.animatableHeaderConstraint.constant = -self.view.frame.height * 0.13
                    self.animatablePopupConstraint.constant = self.view.frame.height
                    self.view.layoutIfNeeded()
                }) {_ in
                    if let scene = self.bouncyCharView.scene as? BouncyBallScene {
                        self.enableInteractions()
                        scene.startGame()
                    }
                }
            }
            else if displayStatus == .menu {
                self.disableBackgroundInteractions()
                bannerView.alpha = 1
                UIView.animate(withDuration: 0, delay: 0, animations: {
                    self.animatableLevelSelectionMenuConstraint.constant = 0
                    self.animatableHeaderConstraint.constant = 0
                    self.animatablePopupConstraint.constant = self.view.frame.height
                    self.view.layoutIfNeeded()
                }) {_ in self.enableInteractions() }
            }
        }
    }
    
    static var gcEnabled = Bool() // Check if the user has Game Center enabled
    static var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    override func viewWillAppear(_ animated: Bool) {
        levelSelectionMenu.reloadData()
        
        levelSelectionMenu.indexPathsForSelectedItems?.forEach { levelSelectionMenu.deselectItem(at: $0, animated: false) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()

        setupHeader()
        setupLevelSelectionMenu()
        setupBouncyCharView()
        setupLevelPopup()
        
        view.backgroundColor = UIColor(named: "bege")
        
        let freeSpace = view.frame.width * 0.575
        let adSize = GADAdSizeFromCGSize(CGSize(width: freeSpace, height: 50))
        bannerView = GADBannerView(adSize: adSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        

        requestIntersticial()
    }
    
    func requestIntersticial() {
        // Intersticial
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .trailing,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .trailing,
                                multiplier: 1,
                                constant: -view.frame.width * 0.025)
            ])
    }
    
    func setupHeader() {
        header = GameHeader()
        
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        animatableHeaderConstraint = header.topAnchor.constraint(equalTo: view.topAnchor)
        
        NSLayoutConstraint.activate([
            animatableHeaderConstraint,
            header.heightAnchor.constraint(equalToConstant: view.frame.height * 0.13),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        header.delegate = self
    }
    
    func setupLevelSelectionMenu() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: -2)
        
        levelSelectionMenu = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.375, height: view.frame.height * 0.8), collectionViewLayout: layout)
        
        levelSelectionMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelSelectionMenu)
        
        animatableLevelSelectionMenuConstraint = levelSelectionMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([
            levelSelectionMenu.topAnchor.constraint(equalTo: header.bottomAnchor),
            animatableLevelSelectionMenuConstraint,
            levelSelectionMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            levelSelectionMenu.widthAnchor.constraint(equalToConstant: view.frame.width * 0.375)
        ])
        
        levelSelectionMenu.showsVerticalScrollIndicator = false
        levelSelectionMenu.register(LevelSelectionCell.self, forCellWithReuseIdentifier: "Cell")
        levelSelectionMenu.allowsSelection = true
        levelSelectionMenu.backgroundColor = UIColor(named: "black")
        
        levelSelectionMenu.delegate = self
        levelSelectionMenu.dataSource = self
    }
    
    func setupBouncyCharView() {
        bouncyCharView = SKView()
        
        bouncyCharView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bouncyCharView)
        
        NSLayoutConstraint.activate([
            bouncyCharView.topAnchor.constraint(equalTo: header.bottomAnchor),
            bouncyCharView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bouncyCharView.leadingAnchor.constraint(equalTo: levelSelectionMenu.trailingAnchor),
            bouncyCharView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let scene = SKScene(fileNamed: "BouncyBall") as? BouncyBallScene {
            scene.scaleMode = .aspectFill
            scene.backgroundColor = UIColor(named: "bege")!
            scene.del = self
            
            bouncyCharView.presentScene(scene)
        }
    }

    func setupLevelPopup() {
        levelPopup = BeginLevelPopup()
        
        levelPopup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelPopup)
        
        animatablePopupConstraint = levelPopup.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height)
        
        NSLayoutConstraint.activate([
            levelPopup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatablePopupConstraint,
            levelPopup.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            levelPopup.heightAnchor.constraint(equalTo: levelPopup.widthAnchor, multiplier: 0.65)
        ])
        
        levelPopup.delegate = self
    }
    
    func disableBackgroundInteractions() {
        header.isUserInteractionEnabled = false
        levelSelectionMenu.isUserInteractionEnabled = false
        bouncyCharView.isUserInteractionEnabled = false
    }
    
    func enableInteractions() {
        header.isUserInteractionEnabled = true
        levelSelectionMenu.isUserInteractionEnabled = true
        bouncyCharView.isUserInteractionEnabled = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(1, LevelHandler.shared.maxLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = levelSelectionMenu.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LevelSelectionCell
        let currLevel = max(1, LevelHandler.shared.maxLevel - indexPath.row)
        
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
        CGSize(width: levelSelectionMenu.frame.width + 4, height:99)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = levelSelectionMenu.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.select()
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.animatablePopupConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        disableBackgroundInteractions()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = levelSelectionMenu.cellForItem(at: indexPath) as! LevelSelectionCell
        cell.deselect()
    }
    
}

extension GameViewController: GameHeaderDelegate {
    func handleRankingButtonTapped() {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: GameViewController.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    func handleStarsButtonTapped() {
        //TODO: Implementar comportamento da loja
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                GameViewController.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        GameViewController.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
            }
            else {
                // Game center is not enabled on the user's device
                GameViewController.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
}

extension GameViewController: BeginLevelPopupDelegate {
    func handleAcceptance() {
        displayStatus = .game
    }
    
    func handleDenial() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.animatablePopupConstraint.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }
        
        enableInteractions()
    }
}

extension GameViewController: BouncyBallSceneDelegate {
    func win() {
        levelsWon += 1
        
        if levelsWon == 3 {
            if let interstitial = interstitial{
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn`t ready")
            }
            levelsWon = 0
        } else {
            let endVC = EndGameMenu(gameResult: .win)
            endVC.view.isUserInteractionEnabled = false
            endVC.delegate = self
            
            present(endVC, animated: true) {
                endVC.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func lose() {
        let endVC = EndGameMenu(gameResult: .lose)
        endVC.view.isUserInteractionEnabled = false
        endVC.delegate = self
        
        present(endVC, animated: true) {
            endVC.view.isUserInteractionEnabled = true
        }
    }
}

extension GameViewController: EndGameMenuDelegate {
    func replayLevel() {
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.startGame()
        }
    }
    
    func goToNextLevel() {
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.startGame()
        }
    }
    
    func goToMenu() {
        displayStatus = .menu
        
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.resetScene()
        }
    }
    
    
}

extension GameViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        let endVC = EndGameMenu(gameResult: .win)
        endVC.view.isUserInteractionEnabled = false
        endVC.delegate = self
        
        present(endVC, animated: true) {
            endVC.view.isUserInteractionEnabled = true
        }
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestIntersticial()
        let endVC = EndGameMenu(gameResult: .win)
        endVC.view.isUserInteractionEnabled = false
        endVC.delegate = self
        
        present(endVC, animated: true) {
            endVC.view.isUserInteractionEnabled = true
        }
//        scene.reset()
    }
}
