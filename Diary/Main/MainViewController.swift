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
//        photo
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(saveButtonClicked))

        navigationItem.rightBarButtonItems = [saveButton]
        
        mainView.mainToSelectButton.addTarget(self, action: #selector(mainToSelectButtonClicked), for: .touchUpInside)
       
    }
    // Realm
    @objc func saveButtonClicked() {
        
        if mainView.firstTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "최소한 제목을 입력해주세요!!", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
            
        } else {
            let alert = UIAlertController(title: "내용을 저장하시겠습니까?", message: nil, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "저장", style: .default) { _ in
                let task = UserDairy(diaryTitle: self.mainView.firstTextField.text ?? "" , diaryContent: self.mainView.mainTextView.text, diaryWriteDate: self.mainView.secondTextField.text ?? "", diaryRegisterDate: Date(), diaryImage: nil)
                // => Record 추가
                
                try! self.localRealm.write {
                    self.localRealm.add(task) // create
                    print("Realm")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let cancle = UIAlertAction(title: "취소", style: .cancel)
            
            [ok, cancle].forEach {
                alert.addAction($0)
            }
            present(alert, animated: true)
        }
        
    }
    
    
    @objc func mainToSelectButtonClicked() {
        let vc = SelectViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


}
