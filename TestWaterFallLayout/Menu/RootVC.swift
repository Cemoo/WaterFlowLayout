//
//  RootVC.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 26.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import ViewPager_Swift

class RootVC: UIViewController {

    let tabs = [
        ViewPagerTab(title: "1", image: UIImage(named: "")),
        ViewPagerTab(title: "2", image: UIImage(named: "")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.image
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewPaddingLeft = 20
        options.fitAllTabsInView = true
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.tabViewHeight = 100
        options.tabType = .basic
        
        let viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self as? ViewPagerControllerDelegate
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RootVC: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        
        switch position {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainVC
            return vc
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "menu1") as! MenuVC1
            return vc
  
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainVC
            return vc
        }
        
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
}
