//
//  AdsProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GoogleMobileAds

protocol AdsInteracting: AnyObject {
    func insertBanner(withSize: CGSize)
    func hideBanner()
    func showBanner()
    func showInterstitial()
}

protocol AdsWorking: AnyObject {
    func getInterstitial() -> GADInterstitialAd?
    func getBanner(withSize: CGSize) -> GADBannerView
    func hideBanner()
    func showBanner()
    func requestInterstitial()
}

protocol AdsPresenting: AnyObject {
    func presentBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ interstitial: GADInterstitialAd)
}

protocol AdsViewControlling: AnyObject {
    func presentBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
}

protocol AdsRouting: AnyObject {
    func insertBanner(_ bannerView: GADBannerView)
    func presentIntestitial(_ intestitial: GADInterstitialAd)
}
