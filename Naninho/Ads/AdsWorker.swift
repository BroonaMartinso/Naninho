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
        case banner = "ca-app-pub-5315052887814879/5865435151"
    }
    
    private var interstitial: GADInterstitialAd?
    private var banner: GADBannerView!
    
    init() {
        requestInterstitial()
    }
    
    func getInterstitial() -> GADInterstitialAd? {
        return interstitial
    }
    
    func getBanner(withSize size: CGSize) -> GADBannerView {
        loadBanner(withSize: size)
        return banner
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
//            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    private func loadBanner(withSize size: CGSize) {
        let adSize = GADAdSizeFromCGSize(size)
        banner = GADBannerView(adSize: adSize)
        banner.adUnitID = AdsUnitIds.banner.rawValue
        banner.load(GADRequest())
    }
    
    func hideBanner() {
        banner.alpha = 0
    }
    
    func showBanner() {
        banner.alpha = 1
    }
}
