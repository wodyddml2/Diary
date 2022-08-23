import UIKit

import RealmSwift
import Kingfisher

extension Notification.Name {
    static let splashImage = NSNotification.Name("splashImageNotification")
}

class MainViewController: BaseViewController {

    let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
        if oldSchemaVersion < 1 {
            migration.enumerateObjects(ofType: UserDairy.className()) { oldObject, newObject in
                
                newObject!["diaryWriteDate"] = "\(oldObject!["diaryWriteDate"] ?? Date())"
            }
        }
    }
    var mainView = MainView()
    lazy var localRealm = try! Realm(configuration: config) // realm 테이블에 데이터를 CRUD할 때, realm 테이블 경로에 접근
    
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
//        folder.badge.plus
//        photo
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        mainView.mainToSelectButton.addTarget(self, action: #selector(mainToSelectButtonClicked), for: .touchUpInside)
//        mainView.sampleButton.addTarget(self, action: #selector(sample), for: .touchUpInside)
       
    }
    // Realm
    @objc func saveButtonClicked() {
        
        let task = UserDairy(diaryTitle: mainView.firstTextField.text ?? "" , diaryContent: mainView.mainTextView.text, diaryWriteDate: mainView.secondTextField.text ?? "", diaryRegisterDate: Date(), diaryImage: nil)
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
