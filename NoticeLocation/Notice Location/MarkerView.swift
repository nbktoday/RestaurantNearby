//
//  MarkerView.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/20/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit

class MarkerView: UIView {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonMarker: UIButton!
    var restaurant:RestaurantCompact?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    
    func loadData() {
        labelName.text = restaurant?.restaurantName
        labelRating.text = "Rating: " + (restaurant?.restaurantRate)!
        labelAddress.text = restaurant?.restaurantAddress
    }
}
