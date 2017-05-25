//
//  RestaurantListFetcher.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/19/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RestaurantListFetcher: BaseFetcher {
    
    
    func getRestaurantsByLocation(latitude:Double, longitude:Double, completed:@escaping (_ isCompleted:Bool) -> Void)-> Void {

        self.dataList.removeAll()
        let url = BaseFetcher.API_URL + ("v3/businesses/search")
        let input: Parameters = [
            "term":"restaurants",
            "latitude":latitude,
            "longitude":longitude,
            "radius": 10000
        ]
        let headers = [
            "Authorization":BaseFetcher.apiToken!
        ]
       self.request = Alamofire.request(url, method: .get, parameters: input, headers: headers).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
        
            let json = JSON(response.result.value as Any)
            let array = json["businesses"].array
            for object in array! {
                let restaurantCompact:RestaurantCompact = RestaurantCompact()
                restaurantCompact.restaurantId =  object["id"].string
                restaurantCompact.restaurantName =  object["name"].stringValue
                restaurantCompact.restaurantRate = object["rating"].stringValue
                restaurantCompact.restaurantAddress = object["location"]["display_address"][0].stringValue + ", " + object["location"]["display_address"][1].stringValue
                let lat:Double = object["coordinates"]["latitude"].double!
                let long:Double = object["coordinates"]["longitude"].double!
                restaurantCompact.restaurantCoordinate = Coordinate(latitude: lat, longitude: long)
                self.dataList.append(restaurantCompact)
            }
            completed(true)
        }
    }
}
