//
//  AdsProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GoogleMobileAds

protocol NonRewardingAdsInteracting: AnyObject {
    func insertBanner(withSize: CGSize)
    func hideBanner()
    func showBanner()
    func showInterstitial()
}

protocol RewardingAdsInteracting: AnyObject {
    func showRewardedAd(for status: EndGameStatus)
}

protocol AdsWorking: AnyObject {
    func getInterstitial() -> GADInterstitialAd?
    func getBanner(withSize: CGSize) -> GADBannerView
    func getRewardedAd() -> GADRewardedAd?
    func hideBanner()
    func showBanner()
    func requestInterstitial()
    func requestRewardedAd()
}

protocol AdsPresenting: AnyObject {
    func presentBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ interstitial: GADInterstitialAd)
    func presentRewardedAd(_ rewardedAd: GADRewardedAd)
    func endInterstitial()
    func endRewardedAd(withPrize completed: Bool)
}

protocol AdsViewControlling: AnyObject {
    func presentBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
    func presentRewardedAd(_ rewardedAd: GADRewardedAd)
    func endInterstitial()
}

protocol AdsRouting: AnyObject {
    func insertBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
}
