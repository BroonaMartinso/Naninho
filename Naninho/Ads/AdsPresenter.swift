//
//  AdsPresenter.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GoogleMobileAds

class AdsPresenter: AdsPresenting {
    private weak var viewController: AdsViewControlling?
    
    init(viewController: AdsViewControlling) {
        self.viewController = viewController
    }
    
    func presentBanner(_ bannerView: GADBannerView) {
        viewController?.presentBanner(bannerView)
    }
    
    func presentIntestitial(_ interstitial: GADInterstitialAd) {
        viewController?.presentIntestitial(interstitial)
    }
    
    func endInterstitial() {
        viewController?.endInterstitial()
    }
    
    func presentRewardedAd(_ rewardedAd: GADRewardedAd) {
        viewController?.presentRewardedAd(rewardedAd)
    }
    
    func endRewardedAd(withPrize completed: Bool) {
        
    }
}
