import UIKit

import RealmSwift
import Kingfisher

extension Notification.Name {
    static let splashImage = NSNotification.Name("splashImageNotification")
}

class MainViewController: BaseViewController {

    var mainView = MainView()
    let localRealm = try! Realm() // realm 테이블에 데이터를 CRUD할 때, realm 테이블 경로에 접근
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Realm is located at:", localRealm.configuration.fileURL!)
        NotificationCenter.default.addObserver(self, selector: #selector(splashImageNotificationObserver(notification:)), name: .splashImage, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .splashImage, object: nil)
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
        mainView.sampleButton.addTarget(self, action: #selector(sample), for: .touchUpInside)
       
    }
    // Realm
    @objc func sample() {
        
        let task = UserDairy(diaryTitle: "오늘의 일기\(Int.random(in: 1...100))", diaryContent: "내용", diaryWriteDate: Date(), diaryRegisterDate: Date(), diaryImage: nil)
        // => Record 추가
        
        try! localRealm.write {
            localRealm.add(task) // create
            print("Realm")
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    @objc func mainToSelectButtonClicked() {
        let vc = SelectViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


}
