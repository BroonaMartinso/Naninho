//
//  AdsWorker.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GoogleMobileAds

class AdsWorker: AdsWorking {
    enum AdsUnitIds: String {
        case interstitial = "ca-app-pub-5315052887814879/9011485006"
        case menuBanner = "ca-app-pub-5315052887814879/5865435151"
        case gameBanner = "ca-app-pub-5315052887814879/7453684692"
        case rewarded = "ca-app-pub-5315052887814879/3494771730"
    }
    
    private var rewardedAd: GADRewardedAd?
    private var interstitial: GADInterstitialAd?
    private var menuBanner: GADBannerView!
    private var gameBanner: GADBannerView!
    
    init() {
        requestInterstitial()
        requestRewardedAd()
    }
    
    func getInterstitial() -> GADInterstitialAd? {
        return interstitial
    }
    
    func getBanner(withSize size: CGSize, case bannerType: BannerCases) -> GADBannerView {
        loadBanner(withSize: size, case: bannerType)
        
        switch bannerType {
        case .menuBanner:
            return menuBanner
        case .gameBanner:
            return gameBanner
        }
    }
    
    func getRewardedAd() -> GADRewardedAd? {
        return rewardedAd
    }
    
    func requestInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AdsUnitIds.interstitial.rawValue,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        })
    }
    
    func requestRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: AdsUnitIds.rewarded.rawValue,
                           request: request,
                           completionHandler:  { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
        })
    }
    
    private func loadBanner(withSize size: CGSize, case bannerType: BannerCases) {
        let adSize = GADAdSizeFromCGSize(size)
        
        switch bannerType {
        case .menuBanner:
            menuBanner = GADBannerView(adSize: adSize)
            menuBanner.adUnitID = AdsUnitIds.menuBanner.rawValue
            menuBanner.load(GADRequest())
        case .gameBanner:
            gameBanner = GADBannerView(adSize: adSize)
            gameBanner.adUnitID = AdsUnitIds.gameBanner.rawValue
            gameBanner.load(GADRequest())
        }
    }
    
    func hideBanner(case bannerType: BannerCases) {
        switch bannerType {
        case .menuBanner:
            menuBanner.alpha = 0
        case .gameBanner:
            gameBanner.alpha = 0
        }
    }
    
    func showBanner(case bannerType: BannerCases) {
        switch bannerType {
        case .menuBanner:
            menuBanner.alpha = 1
        case .gameBanner:
            gameBanner.alpha = 1
        }
    }
}
