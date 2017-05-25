//
//  RestaurantDetail.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/19/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit

class RestaurantDetail: NSObject {
    var restaurantId:String?
    var restaurantName:String?
    var restaurantRate:Float?
    var restaurantImgUrl:String?
    var restaurantReviewCount:Int?
    var restaurantPhone:String?
    var restaurantPrice:String?
    var restaurantCategories:[Category]?
    var restaurantPhotos:[String]?
    var restaurantLocation: Location?
    var restaurantHours:Hours?
    var restaurantTransactions:[String]?
    var restaurantCoordinate:Coordinate?
    
}

struct Category {
    var alias:String
    var title:String
}

struct Location {
    var address1:String
    var address2:String
    var address3:String
    var city:String
    var zipcode:String
    var country:String
    var state:String
    var displayAddress:String
    var crossStreet:String
}

struct Coordinate {
    var latitude:Double
    var longitude:Double
}

struct HourOpen {
    var isOverNight:Bool?
    var start:String?
    var end:String?
    var day:Int?
}

struct Hours {
    var open:[HourOpen]?
    var hourType:String?
    var isOpenNow:Bool?
}
