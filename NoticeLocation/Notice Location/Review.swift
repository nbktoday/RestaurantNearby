//
//  Review.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/24/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit

class Review: NSObject {
    var userImgUrl:String?
    var userName:String?
    var review:String?
    var rating:Int?
    var createdDate:String?
    var url:String?
    
    func dateString(from datetimeString:String) -> String {
        let string = createdDate?.components(separatedBy: " ")[0]
        return string!
    }
    
}
