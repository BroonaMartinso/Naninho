//
//  RewardedAdsInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation
import GoogleMobileAds

class RewardedAdsInteractor: NSObject, RewardingAdsInteracting, GADFullScreenContentDelegate {
    private var presenter: AdsPresenting?
    private var worker: AdsWorking?
    
    init(presenter: AdsPresenting, worker: AdsWorking) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func showRewardedAd(for status: EndGameStatus) {
        if let rewardedAd = worker?.getRewardedAd() {
            rewardedAd.fullScreenContentDelegate = self
            presenter?.presentRewardedAd(rewardedAd)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        worker?.requestRewardedAd()
    }
}
