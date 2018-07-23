//
//  CustomCell.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 23.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var imgThumb: UIImageView!
    var url: String? = ""
    
    @IBOutlet weak var lblTet: UILabel!
    func setImage() {
        self.imgThumb.image = nil
        self.imgThumb.sd_setImage(with: URL(string: self.url!)!) { (image, eror, cache, nil) in
            self.imgThumb.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

