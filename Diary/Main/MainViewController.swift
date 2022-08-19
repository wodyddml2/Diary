import UIKit

import Kingfisher

extension Notification.Name {
    static let splashImage = NSNotification.Name("splashImageNotification")
}

class MainViewController: BaseViewController {

    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(splashImageNotificationObserver(notification:)), name: .splashImage, object: nil)
    }
    
    
    @objc func splashImageNotificationObserver(notification: NSNotification) {
        if let image = notification.userInfo?["image"] as? String {
            self.mainView.mainImageView.kf.setImage(with: URL(string: image))
        }
    }
    
    override func configureUI() {
        navigationItem.title = "Diary"
        navigationItem.backButtonTitle = " "
        
        mainView.mainToSelectButton.addTarget(self, action: #selector(mainToSelectButtonClicked), for: .touchUpInside)
    }
    
    @objc func mainToSelectButtonClicked() {
        let vc = SelectViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


}
