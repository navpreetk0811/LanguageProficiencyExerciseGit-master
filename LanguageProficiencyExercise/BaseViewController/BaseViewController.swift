//
//  BaseViewController.swift
//  LanguageProficiencyExercise
//
//  Created by Navpreet Kaur on 4/18/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var mainTitle = String()
    var arrCountryDetail = CountryFile()
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    // Mark: Loading Data
    func checkConnectivityLoadData( _ data: CountryFile,  _ error: NSError? ){
        
        switch Network.reachability.status {
        case .unreachable:
            print("Your device does not have an internet connectivity")
        case .wwan:
            loadData_()
        case .wifi:
            loadData_()
        }
        callback(arrCountryDetail,nil)
    }
    func loadData_(){
        let webservice  = WebserviceSigleton ()
        self.showLoader(strForMessage: "Loading...")
        webservice.POSTServiceWithParameters(callback:{ (result,error) -> Void in
            if result != nil{
                let response = result! as Dictionary
                
                if let countrytitle = response["title"] as? String{
                    mainTitle = countrytitle
                }
            
                for item in response {
                    
                    let countryFile = CountryFile()
                    
                    if let title = item["title"] as? String{
                        countryFile.title = title
                    }
                    if let description = item["description"] as? String{
                        countryFile.description = description
                    }
                    if let imageURL = item["imageHref"]{
                        countryFile.imageHref = imageURL
                    }
                    self.arrCountryDetail.append(countryFile)
                }
                
            }
        })
    }
}
