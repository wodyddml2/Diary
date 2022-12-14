import UIKit
import PhotosUI

import RealmSwift
import Kingfisher

//extension Notification.Name {
//    static let splashImage = NSNotification.Name("splashImageNotification")
//}

protocol SelectImageDelegate {
    func sendImageData(image:UIImage)
}

class MainViewController: BaseViewController {
    var mainView = MainView()
    
    let repository = UserDairyRepository()
    
    lazy var imagePicker: UIImagePickerController = {
        let view = UIImagePickerController()
        view.delegate = self
        return view
    }()
    let configuration: PHPickerConfiguration = {
       var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        return configuration
    }()
    
    lazy var phPicker: PHPickerViewController = {
       let view = PHPickerViewController(configuration: configuration)
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.mainTextView.delegate = self
        mainView.firstTextField.delegate = self
        mainView.secondTextField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(splashImageNotificationObserver(notification:)), name: .splashImage, object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .splashImage, object: nil)
//    }
//
//    @objc func splashImageNotificationObserver(notification: NSNotification) {
//        if let image = notification.userInfo?["image"] as? String {
//            self.mainView.mainImageView.kf.setImage(with: URL(string: image))
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.endEditing(true)
    }
    
    
    
    
    override func configureUI() {
        navigationItem.title = "Diary"
        navigationItem.backButtonTitle = " "
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))

        let saveButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        var imageButton = UIBarButtonItem()
        if #available(iOS 14.0, *) {
            imageButton = UIBarButtonItem(image: UIImage(systemName: "photo"), primaryAction: nil, menu: menuImageButtonClicked())
        } else {
            imageButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(alertImageButtonClicked))
        }

        navigationItem.rightBarButtonItems = [saveButton, imageButton]
       
    }
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
   
    
    // MARK: 일기 저장 Button Action
    // Realm + 이미지 sandBox의 도큐먼트에 저장
    @objc func saveButtonClicked() {
        
        if mainView.firstTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "제목은 필수로 입력해주세요!!", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
            
        } else {
            let alert = UIAlertController(title: "내용을 저장하시겠습니까?", message: nil, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "저장", style: .default) { _ in
                
                let task = UserDairy(
                    diaryTitle: self.mainView.firstTextField.text ?? "" ,
                    diaryContent: self.mainView.mainTextView.text,
                    diaryWriteDate: self.mainView.secondTextField.text ?? "",
                    diaryRegisterDate: Date(),
                    diaryImage: nil)
                // => Record 추가
                
                do {
                    
                    try! self.repository.localRealm.write {
                        self.repository.localRealm.add(task) // create
                    
                    }
                } catch let error {
                    print(error)
                }
                if let image = self.mainView.mainImageView.image {
                    self.saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
                }
                self.dismiss(animated: true)
            }
            let cancle = UIAlertAction(title: "취소", style: .cancel)
            
            [ok, cancle].forEach {
                alert.addAction($0)
            }
            present(alert, animated: true)
        }
    }
    
   
    // MARK: 이미지 불러오기 위한 Action
    // 14 이후
    func menuImageButtonClicked() -> UIMenu {
        let search = UIAction(title: "UnSplash", image: UIImage(systemName: "magnifyingglass")) { _ in
            let vc = SelectViewController()
            vc.delegate = self
            self.transition(vc, transitionStyle: .push)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        let camera = UIAction(title: "카메라", image: UIImage(systemName: "camera")) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true)
        }
        let gallery = UIAction(title: "갤러리", image: UIImage(systemName: "photo.on.rectangle.angled")) { _ in
            self.present(self.phPicker, animated: true)
        }
        let menu = UIMenu(title: "이미지를 가져올 경로를 정해주세요.", options: .displayInline, children: [search, camera, gallery])
        
        return menu
    }
    // 14 이전
    @objc func alertImageButtonClicked() {
        let alert = UIAlertController(title: "이미지를 가져올 경로를 정해주세요.", message: nil, preferredStyle: .actionSheet)
        
        let search = UIAlertAction(title: "UnSplash", style: .default) { _ in
            let vc = SelectViewController()
            // 같은 프로토콜을 가지고 있다면 self처리가능
            vc.delegate = self
            self.transition(vc, transitionStyle: .push)
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true)
        }
        let gallery = UIAlertAction(title: "갤러리", style: .default) { _ in
            self.present(self.phPicker, animated: true)
        }
        
        [search, camera, gallery].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
    

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.mainView.mainImageView.image = image
            dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.mainView.mainImageView.image = image as? UIImage
                }
            }
        }
    }

}

extension MainViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setKeyboardObserver()
        navigationController?.navigationBar.isHidden = true
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        navigationController?.navigationBar.isHidden = false
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        removeKeyboardObserver()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainView.endEditing(true)
        return true
    }
}

extension MainViewController: SelectImageDelegate {
    func sendImageData(image: UIImage) {
        mainView.mainImageView.image = image
        print(#function)
    }
    
}
