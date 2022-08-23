import UIKit

extension UIViewController {
    func showAlert(title: String, completionHandler: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        present(alert, animated: true)
    }
    
//    func showNavigationItemToMenu() {
//        let 
//    }
}
