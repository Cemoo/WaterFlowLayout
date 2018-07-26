//
//  MainVC.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 24.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import Alamofire
import MoPub


class MainVC: UIViewController {
    
    var itemsArray = [[Item]]()
    var items = [Item]()
    
    @IBOutlet weak var tbItems: UITableView!
    var placer: MPTableViewAdPlacer!
    var positioning = MPClientAdPositioning()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbItems.mp_setDelegate(self)
        tbItems.mp_setDataSource(self)
        
        let nib = UINib(nibName: "AdCell", bundle: nil)
        tbItems.register(nib, forCellReuseIdentifier: "ad")
        fetchData()
        //configAd()
        setPlacer()
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource, MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbItems.mp_dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCell
        cell.items = self.itemsArray[indexPath.row]
        cell.colView.reloadData()
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return self.view.frame.size.height
        
    }
    
    private func calculateHeightForNativeAdCell() -> CGSize {
        let contentSizeWidth = tbItems!.contentSize.width
        let cellWidth: CGFloat
        if false {
            cellWidth = (contentSizeWidth - 16) / 1.0 //32 = 4 * 8 spacing
        } else {
            cellWidth = (contentSizeWidth - 6) / 1.0 //24 = 3 * 8 spacing
        }
        
        let horizontalSizeClass = self.traitCollection.horizontalSizeClass
        let verticalSizeClass = self.traitCollection.verticalSizeClass
      
        var height = cellWidth
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            height = cellWidth * 0.9
        }
        
        return CGSize(width: cellWidth, height: height)
    }
    
    private func setPlacer() {
        let settings = MPStaticNativeAdRendererSettings()
        settings.renderingViewClass = AdCell.self
        settings.viewSizeHandler = { (maxWidth: CGFloat) in
            return CGSize(width: maxWidth, height: 200)
        }
        
        let videoSettings = MOPUBNativeVideoAdRendererSettings()
        videoSettings.renderingViewClass = settings.renderingViewClass
        videoSettings.viewSizeHandler = settings.viewSizeHandler
        
        let videoConfiguration = MOPUBNativeVideoAdRenderer.rendererConfiguration(with: videoSettings)
        let nativeAdConfig = MPStaticNativeAdRenderer.rendererConfiguration(with: settings)
        
        nativeAdConfig?.supportedCustomEvents = ["FlurryNativeCustomEvent", "FacebookNativeCustomEvent", "MPGoogleAdMobNativeCustomEvent", "MPMoPubNativeCustomEvent"]
        
        positioning.enableRepeatingPositions(withInterval: 2)
        
        let sampleAdUnitID = "76a3fefaced247959582d2d2df6f4757"
        let targeting: MPNativeAdRequestTargeting! = MPNativeAdRequestTargeting()
        targeting.desiredAssets = NSSet(objects: kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey) as Set<NSObject>
        
        placer = MPTableViewAdPlacer(tableView: self.tbItems, viewController: self, rendererConfigurations: [nativeAdConfig as Any, videoConfiguration as Any])
        
        placer.loadAds(forAdUnitID: sampleAdUnitID, targeting: targeting)
    }
    
    func setPlacerView() -> MPAdView {
        let adView = MPAdView(adUnitId: "76a3fefaced247959582d2d2df6f4757", size: MOPUB_BANNER_SIZE)
        adView?.delegate = self
        var frame: CGRect = (adView?.frame)!
        var size: CGSize = (adView?.adContentViewSize())!
        frame.origin.y = UIScreen.main.bounds.size.height - size.height
        adView?.frame = frame
        adView?.loadAd()
        return adView!
    }
    
    
}


extension MainVC {
    
    func fetchData() {
        let url: URL = URL(string: "http://server.sprueche-app.de/phpScripts/items.php?hl=de&type=100&amount=10")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data {
                do {
                    print(String.init(data: data, encoding: .utf8))
                    let items = try JSONDecoder().decode(MyData.self, from: data)
                    self.items = items.items!
                    DispatchQueue.main.async {
                        if self.items.count > 0 {
                            self.feedDataForCell(inc: 5)
                            self.tbItems.reloadData()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    self.items = []
                }
            }
        }
    }
    
    
    func feedDataForCell(inc: Int) {
        self.itemsArray = self.items.chunked(by: inc)
    }
    
}

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
