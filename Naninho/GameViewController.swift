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
    private var user = User()
    private var adsRouter: AdsRouting?
    private var adsInteractor: NonRewardingAdsInteracting?
    private var rewardedAdsInteractor: RewardingAdsInteracting?
    private var levelInteractor: LevelInteracting?
    private var levelsWon: Int = 0
    private var header: GameHeader!
    private var levelSelectionMenu: UICollectionView!
    private var bouncyCharView: SKView!
    private var levelPopup: BeginLevelPopup!
    private var beginLevelPopUpsRouter: PopUpRouting?
    private var rewardAdPopUp: GetMoreTimePopup!
    private var rewardAdPopUpRouter: PopUpRouting?
    private var buySkinPopup: BuySkinPopup!
    private var buySkinPopupRouter: PopUpRouting?
    private var animatableLevelSelectionMenuConstraint: NSLayoutConstraint!
    private var animatableHeaderConstraint: NSLayoutConstraint!
    private var animatablePopupConstraint: NSLayoutConstraint!
    private var animatableRewardAdConstraint: NSLayoutConstraint!
    private var animatableBuySkinPopupConstraint: NSLayoutConstraint!
    private var animatableGameSceneConstraint: NSLayoutConstraint!
    private var skinsDelegate: SkinsMenuDelegate!
    private var levelDelegate: LevelMenuDelegate!
    private var timeRemainingCache: Double = 0
    
    override func viewWillAppear(_ animated: Bool) {
        levelSelectionMenu.reloadData()
        levelSelectionMenu.indexPathsForSelectedItems?.forEach { levelSelectionMenu.deselectItem(at: $0, animated: false) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
        setupBouncyCharView()

        let adsPresenter = AdsPresenter(viewController: self)
        let adsWorker = AdsWorker()
        adsInteractor = BannerAndInterstitialAdsInteractor(presenter: adsPresenter, worker: adsWorker)
        adsRouter = AdsRouter(vc: self)
        
        rewardedAdsInteractor = RewardedAdsInteractor(presenter: adsPresenter, worker: adsWorker)
        let scene = bouncyCharView.scene as! BouncyBallScene
        scene.gameViewController = self
        levelInteractor = LevelInteractor(worker: LevelWorker(), presenter: scene)
        
        skinsDelegate = SkinsMenuDelegate()
        levelDelegate = LevelMenuDelegate(levelInteractor: levelInteractor!)
        levelDelegate.delegate = self
        skinsDelegate.delegate = self
        
        setupLevelSelectionMenu()
        setupLevelPopup()
        setupRewardAdPopup()
        setupBuySkinPopup()
        
        view.backgroundColor = UIColor(named: "bege")
        
        let menuBannerWidth = view.frame.width * 0.575
        let gameBannerWidth = view.frame.width * 0.78
        adsInteractor?.insertBanner(withSize: CGSize(width: menuBannerWidth, height: 50), case: .menuBanner)
        adsInteractor?.insertBanner(withSize: CGSize(width: gameBannerWidth, height: 50), case: .gameBanner)
        adsInteractor?.hideBanner(case: .gameBanner)
        
        beginLevelPopUpsRouter = PopUpsRouter(source: self, constraint: animatablePopupConstraint)
        rewardAdPopUpRouter = PopUpsRouter(source: self, constraint: animatableRewardAdConstraint)
        buySkinPopupRouter = PopUpsRouter(source: self, constraint: animatableBuySkinPopupConstraint)
        
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.router = rewardAdPopUpRouter
            user.addListener(scene)
        }
        
        let skinPresenter = SkinPresenter(popUp: buySkinPopup, vc: self)
        user.skinPresenter = skinPresenter
        skinsDelegate.skinInteractor = user

        levelInteractor?.addListener(levelPopup)
        header.update(coins: user.coins, starsObtained: levelInteractor?.starsObtained ?? 0, maxObtainableStars: levelInteractor?.maxObtainableStars ?? 0)
        
        levelDelegate.beginLevelPopUpsRouter = beginLevelPopUpsRouter
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

        let rankingPresenter = RankingPresenter(viewController: self)
        let rankingWorker = RankingWorker()
        let rankingInteractor = RankingInteractor(presenter: rankingPresenter, worker: rankingWorker)
        header.rankingInteractor = rankingInteractor
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
        levelSelectionMenu.register(SkinSelectionCell.self, forCellWithReuseIdentifier: "SkinCell")
        levelSelectionMenu.register(ChangeMenuContextCell.self, forCellWithReuseIdentifier: "ChangeContext")
        levelSelectionMenu.allowsSelection = true
        levelSelectionMenu.backgroundColor = UIColor(named: "black")
        
        levelSelectionMenu.delegate = levelDelegate
        levelSelectionMenu.dataSource = levelDelegate
    }

    func setupBouncyCharView() {
        bouncyCharView = SKView()

        bouncyCharView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bouncyCharView)

        animatableGameSceneConstraint = bouncyCharView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.375 / 2)

        NSLayoutConstraint.activate([
            bouncyCharView.topAnchor.constraint(equalTo: header.bottomAnchor),
            bouncyCharView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            bouncyCharView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bouncyCharView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animatableGameSceneConstraint
        ])

        let aspectRatio = (view.frame.height / view.frame.width)
        if aspectRatio > 2 {
            if let scene = SKScene(fileNamed: "BouncyBall") as? BouncyBallScene {
                scene.scaleMode = .aspectFill
                scene.backgroundColor = UIColor(named: "bege")!
                scene.del = self

                bouncyCharView.presentScene(scene)
            }
        } else {
            if let scene = SKScene(fileNamed: "GameScene") as? BouncyBallScene {
                scene.naninhoName = user.selectedSkin.imageName
                scene.scaleMode = .aspectFill
                scene.backgroundColor = UIColor(named: "bege")!
                scene.del = self
                scene.router = self.rewardAdPopUpRouter
                scene.naninhoName = user.selectedSkin.imageName
                
                bouncyCharView.presentScene(scene)
            }
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
    
    func setupBuySkinPopup() {
        buySkinPopup = BuySkinPopup()
        
        buySkinPopup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buySkinPopup)
        
        animatableBuySkinPopupConstraint = buySkinPopup.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height)
        
        NSLayoutConstraint.activate([
            buySkinPopup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatableBuySkinPopupConstraint,
            buySkinPopup.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            buySkinPopup.heightAnchor.constraint(equalTo: buySkinPopup.widthAnchor, multiplier: 0.65)
        ])
        
        buySkinPopup.delegate = self
    }
    
    func setupRewardAdPopup() {
        rewardAdPopUp = GetMoreTimePopup()
        
        rewardAdPopUp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rewardAdPopUp)
        
        animatableRewardAdConstraint = rewardAdPopUp.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height)
        
        NSLayoutConstraint.activate([
            rewardAdPopUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatableRewardAdConstraint,
            rewardAdPopUp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            rewardAdPopUp.heightAnchor.constraint(equalTo: rewardAdPopUp.widthAnchor, multiplier: 0.65)
        ])
        
        rewardAdPopUp.delegate = self
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
    
    func showEndVC(_ vc: EndGameMenu) {
        vc.view.isUserInteractionEnabled = false
        vc.delegate = self
        
        present(vc, animated: true) {
            vc.view.isUserInteractionEnabled = true
        }
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
}

extension GameViewController: RankingViewControlling {
    func showRanking(_ vc: GKGameCenterViewController) {
        vc.gameCenterDelegate = self
        present(vc, animated: true)
    }
}

extension GameViewController: AdsViewControlling {
    func presentBanner(_ bannerView: GADBannerView, case bannerType: BannerCases) {
        bannerView.rootViewController = self
        adsRouter?.insertBanner(bannerView, case: bannerType)
    }
    
    func presentIntestitial(_ intestitial: GADInterstitialAd) {
        adsRouter?.presentIntestitial(intestitial)
    }
    
    func presentRewardedAd(_ rewardedAd: GADRewardedAd, for reward: RewardedAdsCases) {
        rewardedAd.present(fromRootViewController: self) { [self] in
            switch reward {
            case .moreTime:
                if let scene = self.bouncyCharView.scene as? BouncyBallScene {
                    scene.setTime(TimeInterval(30))
                }
            case .doubleCoins:
                break
            case .moreCoins:
                self.user.getCoins(20)
                self.header.update(coins: user.coins, starsObtained: levelInteractor?.starsObtained ?? 0, maxObtainableStars: levelInteractor?.maxObtainableStars ?? 0)
            }
        }
    }
    
    func endInterstitial(for adCase: IntersticialAdsCases) {
        switch adCase {
        case .replay:
            adsInteractor?.showBanner(case: .gameBanner)
            levelInteractor?.replayLevel()
        case .win:
            levelInteractor?.completeLevel(timeRemaining: timeRemainingCache)
        }
    }
}

extension GameViewController: BeginLevelPopupDelegate {
    func handleAcceptance() {
        beginLevelPopUpsRouter?.hide()
        adsInteractor?.hideBanner(case: .menuBanner)
        adsInteractor?.showBanner(case: .gameBanner)
        
        self.disableBackgroundInteractions()
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.animatableLevelSelectionMenuConstraint.constant = -self.view.frame.width * 0.375
            self.animatableHeaderConstraint.constant = -self.view.frame.height * 0.13
            self.animatableGameSceneConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) {_ in
            self.enableInteractions()
            self.levelInteractor?.startCurrentLevel()
        }
    }
    
    func handleDenial() {
        beginLevelPopUpsRouter?.hide()
        enableInteractions()
    }
}

extension GameViewController: GetMoreTimePopupDelegate {
    func playVideo() {
        rewardedAdsInteractor?.showRewardedAd(for: .moreTime)
    }
    
    func dontPlayVideo() {
        if let scene = self.bouncyCharView.scene as? BouncyBallScene {
            scene.dontAddTime()
        }
    }
}

extension GameViewController: BouncyBallSceneDelegate {
    func endGame(result: GameResult) {
        adsInteractor?.hideBanner(case: .gameBanner)
        if result.timeRemaining >= 0 {
            levelsWon += 1
            
            if levelsWon == 3 {
                timeRemainingCache = result.timeRemaining
                adsInteractor?.showInterstitial(for: .win)
                levelsWon = 0
                return
            }
        }
        
        levelInteractor?.completeLevel(timeRemaining: result.timeRemaining)
        user.getCoins(result.coins)
    }
    
}

extension GameViewController: EndGameMenuDelegate {
    func startNewGame() {
        levelInteractor?.playNextLevel()
        adsInteractor?.showBanner(case: .gameBanner)
    }
    
    func goToMenu() {
        self.disableBackgroundInteractions()
        adsInteractor?.showBanner(case: .menuBanner)
        header.update(coins: user.coins, starsObtained: levelInteractor?.starsObtained ?? 0, maxObtainableStars: levelInteractor?.maxObtainableStars ?? 0)
        
        UIView.animate(withDuration: 0, delay: 0, animations: {
            self.animatableLevelSelectionMenuConstraint.constant = 0
            self.animatableHeaderConstraint.constant = 0
            self.animatablePopupConstraint.constant = self.view.frame.height
            self.animatableGameSceneConstraint.constant = self.view.frame.width * 0.375 / 2
            self.view.layoutIfNeeded()
        }) {_ in self.enableInteractions() }
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.resetScene()
        }
    }
    
    func replay() {
        adsInteractor?.showInterstitial(for: .replay)
    }
}

extension GameViewController: GameHeaderDelegate {
    func skins() {

    }
}

extension GameViewController: SideMenuDelegate {
    func changeContextTo(_ context: MenuContext) {
        disableBackgroundInteractions()
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.animatableLevelSelectionMenuConstraint.constant = -self.view.frame.width * 0.375
            self.view.layoutIfNeeded()
        }) {_ in
            self.levelSelectionMenu.dataSource = nil
            switch context {
            case .levels:
                self.levelSelectionMenu.delegate = self.levelDelegate
                self.levelSelectionMenu.dataSource = self.levelDelegate
            case .skins:
                self.levelSelectionMenu.delegate = self.skinsDelegate
                self.levelSelectionMenu.dataSource = self.skinsDelegate
            }
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.animatableLevelSelectionMenuConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { _ in
                self.enableInteractions()
                self.levelSelectionMenu.reloadData()
            }
        }
    }
    
    func handleLevelSelection(levelSelected: Int) {
//        levelInteractor?.setLevel(to: levelSelected)
//        beginLevelPopUpsRouter?.show()
        disableBackgroundInteractions()
    }
    
    func select(skin: Skin) {
        user.select(skin)
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.naninhoName = skin.imageName
        }
    }
}

extension GameViewController: SkinViewControlling {
    func showPopup() {
        disableBackgroundInteractions()
        buySkinPopupRouter?.show()
    }
}

extension GameViewController: BuySkinPopupDelegate {
    func buy(skin: Skin) {
        user.buy(skin: skin)
        buySkinPopupRouter?.hide()
        enableInteractions()
        user.select(skin)
        if let scene = bouncyCharView.scene as? BouncyBallScene {
            scene.naninhoName = skin.imageName
        }
    }
    
    func dontBuySkin() {
        buySkinPopupRouter?.hide()
        enableInteractions()
    }
    
    func showAdsForCoins() {
        rewardedAdsInteractor?.showRewardedAd(for: .moreCoins)
        buySkinPopupRouter?.hide()
        enableInteractions()
    }
}
