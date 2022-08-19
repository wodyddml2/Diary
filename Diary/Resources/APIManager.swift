import UIKit

import Alamofire
import SwiftyJSON

class RequestAPIManager {
    static let shared = RequestAPIManager()
    
    private init() { }
    
    func requestSplash() {
        
        let url = ""
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
