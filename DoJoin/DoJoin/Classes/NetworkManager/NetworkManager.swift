//
//  NetworkManager.swift
//  DoJoin
//
//  Created by Ijaz on 02/10/2020.
//

import UIKit
import Alamofire

typealias onSuccess = (Any) -> Void
typealias onFailure = (Int, String) -> Void

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    private override init() {
        
    }
    
    // MARK: - Network calls
    
    func getProfileRequest(success: onSuccess?, failure: onFailure?)
    {
        apiRequestByAlamofire(path: APIConstants.profile, methodType: .get, success: success, failure: failure)
    }
    
    func getDiscussionsRequest(success: onSuccess?, failure: onFailure?)
    {
        apiRequestByAlamofire(path: APIConstants.discussions, methodType: .get, success: success, failure: failure)
    }
    
    // MARK: - Alamofire
    
    private func apiRequestByAlamofire(path: String, methodType: HTTPMethod, success: onSuccess?, failure: onFailure?)
    {
        Alamofire.request(path, method: methodType, encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                /* Handling response in success case */
                if let httpResponse = response.response {
                    print(httpResponse.statusCode)
                    
                    if (httpResponse.statusCode == 200) {
                        if response.result.value != nil {
                            let result = (response.result.value! as? NSDictionary)!
                            success!(result)
                        }
                        
                    }
                    else{
                        failure!(1, "Some error has occurred.")
                    }
                }
                break
            case .failure(let error):
                /* Request Failed */
                //    print(params)
                print("Error:\n" + response.result.description + "\n" + error.localizedDescription)
                failure!(1, error.localizedDescription)
                break
            }
        }
    }
}
