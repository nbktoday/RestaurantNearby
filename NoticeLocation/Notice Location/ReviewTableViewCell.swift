//
//  ReviewTableViewCell.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/24/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewStar1: UIImageView!
    @IBOutlet weak var imgViewStar2: UIImageView!
    @IBOutlet weak var imgViewStar3: UIImageView!
    @IBOutlet weak var imgViewStar4: UIImageView!
    @IBOutlet weak var imgViewStar5: UIImageView!
    @IBOutlet weak var labelNameUser: UILabel!
    @IBOutlet weak var labelReview: UILabel!
    @IBOutlet weak var labelCreatedDate: UILabel!
    var reviewObj: Review?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewUser.layer.cornerRadius = self.imgViewUser.frame.size.width/2
        self.imgViewUser.clipsToBounds = true
    }

    func loadDataView() {
        self.imgViewUser.sd_setImage(with: URL(string: (reviewObj?.userImgUrl)!),placeholderImage: nil)
        self.labelNameUser.text = reviewObj?.userName
        self.labelReview.text = reviewObj?.review
        self.labelCreatedDate.text = reviewObj?.dateString(from: (reviewObj?.createdDate)!)
        switch (reviewObj?.rating)! {
        case 1:
            self.imgViewStar1.isHidden = false
        case 2:
            self.imgViewStar1.isHidden = false
            self.imgViewStar2.isHidden = false
        case 3:
            self.imgViewStar1.isHidden = false
            self.imgViewStar2.isHidden = false
            self.imgViewStar3.isHidden = false
        case 4:
            self.imgViewStar1.isHidden = false
            self.imgViewStar2.isHidden = false
            self.imgViewStar3.isHidden = false
            self.imgViewStar4.isHidden = false
        case 5:
            self.imgViewStar1.isHidden = false
            self.imgViewStar2.isHidden = false
            self.imgViewStar3.isHidden = false
            self.imgViewStar4.isHidden = false
            self.imgViewStar5.isHidden = false
        default:
            self.imgViewStar1.isHidden = false
        }
    }
    
}
