//
//  AdsProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GoogleMobileAds

protocol NonRewardingAdsInteracting: AnyObject {
    func insertBanner(withSize: CGSize, case bannerType: BannerCases)
    func hideBanner(case bannerType: BannerCases)
    func showBanner(case bannerType: BannerCases)
    func showInterstitial(for adCase: IntersticialAdsCases)
}

protocol RewardingAdsInteracting: AnyObject {
    func showRewardedAd(for reward: RewardedAdsCases)
}

protocol AdsWorking: AnyObject {
    func getInterstitial() -> GADInterstitialAd?
    func getBanner(withSize size: CGSize, case bannerType: BannerCases) -> GADBannerView
    func getRewardedAd() -> GADRewardedAd?
    func hideBanner(case bannerType: BannerCases)
    func showBanner(case bannerType: BannerCases)
    func requestInterstitial()
    func requestRewardedAd()
}

protocol AdsPresenting: AnyObject {
    func presentBanner(_ bannerView: GADBannerView, case bannerType: BannerCases)
    func presentIntestitial(_ interstitial: GADInterstitialAd)
    func presentRewardedAd(_ rewardedAd: GADRewardedAd, for reward: RewardedAdsCases)
    func endInterstitial(for adCase: IntersticialAdsCases)
    func endRewardedAd(withPrize completed: Bool)
}

protocol AdsViewControlling: AnyObject {
    func presentBanner(_ bannerView: GADBannerView, case bannerType: BannerCases)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
    func presentRewardedAd(_ rewardedAd: GADRewardedAd, for reward: RewardedAdsCases)
    func endInterstitial(for adCase: IntersticialAdsCases)
}

protocol AdsRouting: AnyObject {
    func insertBanner(_ bannerView: GADBannerView, case bannerType: BannerCases)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
}
