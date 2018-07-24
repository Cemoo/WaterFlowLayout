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
        // Do any additional setup after loading the view.
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource, MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbItems.mp_dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCell
        cell.items = self.items
        cell.colView.reloadData()
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return self.view.frame.size.height
        } else {
            return 1
        }
        
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
        
        // Creates a table view ad placer that uses a sample cell for its layout.
        // Replace the defaultAdRenderingClass with your own subclass that implements MPAdRendering.
        
        placer = MPTableViewAdPlacer(tableView: self.tbItems, viewController: self, rendererConfigurations: [nativeAdConfig as Any, videoConfiguration as Any])
        
       // placer = MPTableViewAdPlacer(tableView: self.tbItems, viewController: self, adPositioning: positioning, rendererConfigurations: [nativeAdConfig as Any, videoConfiguration as Any])
        
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
        let url: URL = URL(string: "http://server.sprueche-app.de/phpScripts/items.php?hl=de&type=100&amount=7")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data {
                do {
                    print(String.init(data: data, encoding: .utf8))
                    let items = try JSONDecoder().decode(MyData.self, from: data)
                    self.items = items.items!
                    DispatchQueue.main.async {
                        if self.items.count > 0 {
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
}
