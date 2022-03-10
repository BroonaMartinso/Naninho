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
    func showInterstitial(for adCase: IntersticialAdsCases)
}

protocol RewardingAdsInteracting: AnyObject {
    func showRewardedAd(for reward: RewardedAdsCases)
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
    func presentRewardedAd(_ rewardedAd: GADRewardedAd, for reward: RewardedAdsCases)
    func endInterstitial(for adCase: IntersticialAdsCases)
    func endRewardedAd(withPrize completed: Bool)
}

protocol AdsViewControlling: AnyObject {
    func presentBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
    func presentRewardedAd(_ rewardedAd: GADRewardedAd, for reward: RewardedAdsCases)
    func endInterstitial(for adCase: IntersticialAdsCases)
}

protocol AdsRouting: AnyObject {
    func insertBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
}
