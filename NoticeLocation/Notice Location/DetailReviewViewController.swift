//
//  DetailReviewViewController.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/24/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit

class DetailReviewViewController: UIViewController {

    var url:String?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url:URL(string:url!)!))
    }

}
