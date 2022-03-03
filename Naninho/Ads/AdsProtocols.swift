//
//  AdsProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GoogleMobileAds

protocol AdsInteracting: AnyObject {
    func hideBanner()
    func showBanner()
    func showInterstitial()
}

protocol AdsWorking: AnyObject {
    
    func getInterstitial() -> GADInterstitialAd?
    func getBanner(withSize: CGSize) -> GADBannerView
    
}
