//
//  ViewController.swift
//  TaleTree
//
//  Created by UFL on 16/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    
    
    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "services.com": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
}

typealias CompletionHandler = (_ response:(Bool, Any)) -> Void

class APIServices: UIViewController {
    
    class func postDataToServer(url:String, parameters: NSMutableDictionary, controller: UIViewController,headers1: [String : String]? ,completionHandler: @escaping CompletionHandler)
    {
        SVProgressHUD.show()
        
        //  let headers1: [String : String]?
        // let sdf = headers: [String : String]?)
        Alamofire.request(url, method: .post, parameters: parameters as? [String:Any] ,encoding: JSONEncoding.default, headers:getHeaders(headers:headers1)).responseJSON {
            response in
            
            
            
            SVProgressHUD.dismiss()
            
            switch response.result {
            case .success:
                if let theJSONData = try? JSONSerialization.data(withJSONObject: response.value as Any, options:[])
                {
                    do{
                        
                        //   print(theJSONData)
                        
                    }
                    
                }
                
                
                break
            case .failure(let error):
                print(error)
                
                //    completionHandler((false,response.value as Any))
                
                let alert = UIAlertController(title: "", message: "Unable to connect server", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    class func getHeaders(headers: [String : String]?) -> [String : String]{
        
        let clientID = "CHWGjBL9S4ghwJeMx1QHmboBDyFAsihA9heKc6Jy"
        let client_secret = "kp78SLBOCZFjzdD6b4BECN73ZTDe8YU2L13XrJaYEOEC1wNOIEPnOxDrTd4QAaDVy7tzDEuVsOjE7RfIPKsfGgyxCXQgq9jk5UbLm6anOlmAAO0BKPWzynQSle8Kd5XJ"
        
        let ResultString = "\(clientID):\(client_secret)"
        
        let base64Encoded = Data(ResultString.utf8).base64EncodedString()
        
        let autStr = "Basic \(base64Encoded)"
        
       // print(autStr)
        
        var defaultHeaders :HTTPHeaders = ["Authorization" : autStr, "content-type": "application/x-www-form-urlencoded"]
    
     //   print(defaultHeaders)
        if let headers = headers{
            for header in headers {
                defaultHeaders[header.key] = header.value
              //  print(defaultHeaders)
            }
        }
        return defaultHeaders
    }
    
}
