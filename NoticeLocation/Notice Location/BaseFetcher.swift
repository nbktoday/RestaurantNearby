//
//  BaseFetcher.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/19/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BaseFetcher: NSObject {
    static let API_URL:String = "https://api.yelp.com/"
    static var apiToken:String?
    static let resultCountDefault:Int = 20
    var data = [Any]()
    var code = -1
    var request: Alamofire.Request?
    var dataList = [Any]()
    
    class func getToken (){
        let urlToken:String = "\(API_URL)oauth2/token"
        let parameters:Parameters = [
            "grant_type":"OAuth 2.0",
            "client_id" : APIKey.YELP_CLIENT_ID,
            "client_secret": APIKey.YELP_CLIENT_SECRET
        ]
        Alamofire.request(urlToken, method: .post, parameters: parameters, headers: nil).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            let json = JSON(response.result.value as Any)
            let accessToken = json["access_token"]
            let tokenType = json["token_type"]
            apiToken = "\(tokenType) \(accessToken)"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CanAccessAPI"), object: nil)
        }
    }
}

