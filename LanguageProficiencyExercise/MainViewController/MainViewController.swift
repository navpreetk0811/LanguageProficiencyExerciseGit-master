//
//  MainViewController.swift
//  LanguageProficiencyExercise
//
//  Created by Navpreet Kaur on 4/17/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit
import Snapkit

class MainViewController: BaseViewController {

    let tableView = UITableView()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        
        self.checkConnectivityLoadData(callback:{ (result,error) -> Void in
            if result != nil{
                self.tableView.reloadData()
            }
        })
    }
    // Mark: PullToRefresh
    
    @objc func refreshData() {
        self.checkConnectivityLoadData(callback:{ (result,error) -> Void in
            if result != nil{
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    // Mark: Update Status
    
    @objc func statusManager(_ notification: Notification) {
        // loading data from Base class
        self.checkConnectivityLoadData(callback:{ (result,error) -> Void in
            if result != nil{
                self.tableView.reloadData()
            }
        })
    }

}


// MARK: TableView DataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCountryDetail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as CustomTableViewCell
        cell.countryDetail = arrCountryDetail[indexPath.row]
        return cell
    }
}
// MARK: Configure Cell Class
class CustomTableViewCell: UITableViewCell {
    
    let imageView_      = UIImageView()
    let descLabel       = UILabel()
    let titleLabel      = UILabel()
    var countryDetail   = CountryFile()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       setImageView()
       setTitleLabel()
       setDescLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Constraints
    func setImageView(){
        contentView.addSubview(imageView_)
        ImageLoader.sharedLoader.imageForUrl(countryDetail.imageHref, completionHandler:{(image: UIImage?, url: String) in
            imageView_.image = image
        })
        
        imageView_.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).with.offset(2)
            make.bottom.equalTo(contentView).with.offset(2)
            make.left.equalTo(contentView).with.offset(2)
            make.width.equalTo(50)
        }
    }
    
    func setTitleLabel(){
        titleLabel.attributedPlaceholder = NSAttributedString(string: Localizable.strings.title, attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFontOfSize(19)
        titleLabel.text = countryDetail.title
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).with.offset(2)
            make.left.equalTo(imageView_).with.offset(2)
            make.right.equalTo(contentView).with.offset(2)
        }
    }
    
    func setDescLabel(){
        descLabel.attributedPlaceholder = NSAttributedString(string: Localizable.strings.description, attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.font = UIFont.systemFontOfSize(19)
        descLabel.text = countryDetail.description
        contentView.addSubview(descLabel)
        descLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel).with.offset(2)
            make.left.equalTo(imageView_).with.offset(2)
            make.right.equalTo(contentView).with.offset(2)
            make.bottom.equalTo(contentView).with.offset(2)
        }
    }
}


