//
//  DetailViewController.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 5/21/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import PKHUD

class DetailViewController: UIViewController {

    @IBOutlet weak var tbData: UITableView!
    
    let fetcher = DetailRestaurantFetcher()
    var restaurantId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbData.register(UINib.init(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .plain, target: nil, action: nil)
        getDetail()
    }
    
    func getDetail() {
        HUD.flash(HUDContentType.systemActivity, delay: 10)
        fetcher.getRestaurantDetail(id: restaurantId!) { (result) in
            self.loadHeaderView()
            self.fetcher.getRestaurantReviews(id: self.restaurantId!, completed: { (completed) in
                HUD.hide()
                self.title = self.fetcher.restaurant?.restaurantName
                self.tbData.reloadData()
            })
            
        }
    }
    
    func loadHeaderView() -> Void {
        let headerView:DetailHeaderView = UIView.fromNib()
        if fetcher.restaurant != nil {
            var categoriesString:String = ""
            let count = fetcher.restaurant?.restaurantCategories?.count
            for i in 0 ... count!-1 {
                let cate:Category = (fetcher.restaurant?.restaurantCategories![i])!
                if i == 0 {
                    categoriesString = cate.title
                } else {
                    categoriesString = categoriesString + (", \(cate.title)")
                }
            }
            
            headerView.loadDataView(images:(fetcher.restaurant?.restaurantPhotos)!, name: (fetcher.restaurant?.restaurantName!)!, address: (fetcher.restaurant?.restaurantLocation?.displayAddress)!, phone: (fetcher.restaurant?.restaurantPhone!)!, rating: String(describing:(fetcher.restaurant?.restaurantRate!)!),categories: categoriesString)
            self.tbData.tableHeaderView = headerView
        }
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return fetcher.dataList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fetcher.dataList.count > 0 {
            let width = Utilities.widthScreen - 16
            let review = fetcher.dataList[indexPath.row] as! Review
            let attributeString:NSAttributedString = NSAttributedString.init(string: review.review!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)])
            let height =  attributeString.height(withConstrainedWidth: width) + 80
            return height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && fetcher.dataList.count > indexPath.row{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
            let review = fetcher.dataList[indexPath.row] as! Review
            cell.reviewObj = review
            cell.loadDataView()
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:SectionHeaderView = UIView.fromNib()
        switch section {
        case 0:
            view.labelTitle.text = "\(fetcher.dataList.count) reviews"
        default:
            view.labelTitle.text = "Photos"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0   {
            tableView.deselectRow(at: indexPath, animated: true)
            let review:Review = fetcher.dataList[indexPath.row] as! Review
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let detailReviewVC = storyboard.instantiateViewController(withIdentifier: "DetailReviewViewController") as! DetailReviewViewController
            detailReviewVC.url = review.url
            self.navigationController?.pushViewController(detailReviewVC, animated: true)
        }
    }
}
