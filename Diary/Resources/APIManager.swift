import UIKit

import Alamofire
import SwiftyJSON

class RequestAPIManager {
    static let shared = RequestAPIManager()
    
    private init() { }
    
    func requestSplash(page: Int, query: String, completionHandler: @escaping ([String], Int) -> ()) {
        
        let url = "https://api.unsplash.com/search/photos?page=\(page)&query=\(query)&client_id=\(APIKey.splash)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let imageList = json["results"].arrayValue.map {
                    $0["urls"]["regular"].stringValue
                }
                let total = json["total_pages"].intValue
            
                completionHandler(imageList, total)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
