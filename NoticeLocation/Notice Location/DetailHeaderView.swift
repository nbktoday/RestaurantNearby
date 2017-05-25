//
//  DetailHeaderView.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/21/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class DetailHeaderView: UIView {
    
    
    @IBOutlet weak var scrollViewImg: UIScrollView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    
    override func draw(_ rect: CGRect) {
        labelRating.layer.cornerRadius = 10.0
        labelRating.clipsToBounds = true
        super.draw(rect)
    }
    
    func loadDataView(images:[String], name: String, address:String, phone:String, rating:String, categories:String) -> Void {
        self.loadImage(images: images)
        labelName.text = name
        labelRating.text = rating
        labelAddress.text = address
        labelPhone.text = phone
        labelCategories.text = categories
    }
    
    func loadImage(images:[String]) {
        let size = CGSize.init(width: Utilities.widthScreen, height: 250)
        for i in 0...images.count-1 {
            let imageView:UIImageView = UIImageView.init(frame: CGRect.init(x: (CGFloat(i))*size.width, y: 0, width: Utilities.widthScreen, height: size.height))
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            let imageUrl = images[i]
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "restaurant_default"))
            self.scrollViewImg.addSubview(imageView)
        }
        self.scrollViewImg.contentSize = CGSize.init(width: (CGFloat(images.count))*Utilities.widthScreen, height: 250)
        self.scrollViewImg.isPagingEnabled = true
    }
}
