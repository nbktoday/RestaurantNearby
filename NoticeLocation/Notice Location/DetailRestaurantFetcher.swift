//
//  DetailRestaurantFetcher.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/23/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailRestaurantFetcher: BaseFetcher {
    
    var restaurant:RestaurantDetail?
    var totalReviews:Int = 1
    
    func getRestaurantDetail(id: String, completed:@escaping (_ isCompleted:Bool) -> Void)-> Void {
        let url = ("\(BaseFetcher.API_URL)v3/businesses/\(id)")
        let headers = [
            "Authorization":BaseFetcher.apiToken!
        ]
        self.request = Alamofire.request(url, method: .get, parameters: nil, headers: headers).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            
            let object = JSON(response.result.value as Any)
            let restaurant:RestaurantDetail = RestaurantDetail()
            
            restaurant.restaurantId =  object["id"].string
            restaurant.restaurantName =  object["name"].stringValue
            restaurant.restaurantImgUrl = object["image_url"].stringValue
            restaurant.restaurantPhone = object["display_phone"].stringValue
            restaurant.restaurantReviewCount = object["review_count"].intValue
            restaurant.restaurantRate = object["rating"].floatValue
            restaurant.restaurantPrice = object["price"].stringValue
            
            // categories
            restaurant.restaurantCategories = [Category]()
            let listCategories:Array = object["categories"].arrayValue
            for item in listCategories {
                let alias = item["alias"].stringValue
                let title = item["title"].stringValue
                let category:Category = Category(alias: alias, title:title)
                restaurant.restaurantCategories?.append(category)
            }
            
            // location
            let location = object["location"]
            let add1 = location["address1"].stringValue
            let add2 = location["address2"].stringValue
            let add3 = location["address3"].stringValue
            let city = location["city"].stringValue
            let zipcode = location["zip_code"].stringValue
            let country = location["country"].stringValue
            let state = location["state"].stringValue
            let crossStr = location["cross_streets"].stringValue
            let array = location["display_address"].array
            let displayAdd = ("\(array?[0].stringValue ?? ""), \(array?[1].stringValue ?? "")")
            restaurant.restaurantLocation = Location(address1: add1,address2: add2,address3: add3,city: city,zipcode: zipcode,country: country,state: state,displayAddress: displayAdd,crossStreet: crossStr)
            
            // coordinate
            let coordinateJson = object["coordinates"]
            let latitude = coordinateJson["latitude"].double
            let longitude = coordinateJson["longitude"].double
            let coordinate:Coordinate = Coordinate(latitude: latitude!,longitude: longitude!)
            restaurant.restaurantCoordinate = coordinate
            
            // photos
            restaurant.restaurantPhotos = object["photos"].arrayValue.map {$0.stringValue}
            
            // hours
            let hourType = object["hours"][0]["hours_type"].stringValue
            
            let isOpenNow = object["hours"][0]["is_open_now"].boolValue
            var arrayHours = [HourOpen]()
            let opens = object["hours"][0]["open"].arrayValue
            for item in opens {
                let isOvernight = item["is_overnight"].boolValue
                let start = item["start"].stringValue
                let end = item["end"].stringValue
                let day = item["day"].intValue
                let hourOpen = HourOpen(isOverNight:isOvernight,start:start,end:end,day:day)
                arrayHours.append(hourOpen)
            }
            restaurant.restaurantHours = Hours(open:arrayHours,hourType:hourType,isOpenNow:isOpenNow)

            // transactions
            restaurant.restaurantTransactions = object["transactions"].arrayValue.map {$0.stringValue}
            self.restaurant = restaurant
            completed(true)
            
        }
    }
    
    func getRestaurantReviews(id:String, completed:@escaping (_ isCompleted:Bool) -> Void)-> Void {
        let url = ("\(BaseFetcher.API_URL)v3/businesses/\(id)/reviews")
        let headers = [
            "Authorization":BaseFetcher.apiToken!
        ]
        self.request = Alamofire.request(url, method: .get, parameters: nil, headers: headers).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization

            let object = JSON(response.result.value as Any)
            let array = object["reviews"].arrayValue
            self.totalReviews = object["total"].intValue
            for item in array {
                let reviewObj = Review()
                reviewObj.review = item["text"].stringValue
                reviewObj.rating = item["rating"].intValue
                reviewObj.createdDate = item["time_created"].stringValue
                reviewObj.userName = item["user"]["name"].stringValue
                reviewObj.userImgUrl = item["user"]["image_url"].stringValue
                reviewObj.url = item["url"].stringValue
                self.dataList.append(reviewObj)
            }
            completed(true)
        }
    }
    
}
