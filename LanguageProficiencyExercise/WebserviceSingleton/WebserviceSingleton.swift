import Foundation
class WebserviceSigleton {
    
    // MARK:-- POST  Request Method
    //To POST data from Remote resource.Returns NSDictionary Object
    
    private let baseUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    func POSTServiceWithParameters(callback:@escaping ( _ data: Dictionary<String, AnyObject>?,  _ error: NSError? ) -> Void)  {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.timeoutIntervalForResource = 120
        
        let url =  "\(baseUrl)"
       
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        print("Request POST URL:\(url) PARAMS:\(params) HEADER: ")
        
        manager.request(url, method: .get, parameters: params, encoding:  URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            guard response.result.error == nil else {
                print("Error for POST :\(urlString):\(response.result.error!)")
                callback(nil , response.result.error! as NSError? )
                return
            }
            if let value = response.result.value {
                //print("JSON: \(value)")
                if let result = value as? Dictionary<String, AnyObject> {
                    print("Response for POST :\(urlString):\(value)")
                    callback(result , nil )
                }
            }
        }
    }
    
}
class Downloader {
   
}
