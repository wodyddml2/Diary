import UIKit

import Kingfisher
import JGProgressHUD

class SelectViewController: BaseViewController {
    let hud = JGProgressHUD()
    
    var delegate: SelectImageDelegate?
    var selectImage: UIImage? // 1.
    var selectIndexPath: IndexPath?
    
    
    let mainView = SelectView()
    
    var pageCount = 1
    
    var imageList: [String] = []
    var totalPage: Int?
    
//    var postSplashImage: String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func configureUI() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonClicked))
        
        mainView.splashCollectionView.delegate = self
        mainView.splashCollectionView.dataSource = self
        mainView.splashCollectionView.prefetchDataSource = self
        
        mainView.splashSearchBar.delegate = self

        mainView.splashCollectionView.register(SelectCollectionViewCell.self, forCellWithReuseIdentifier: SelectCollectionViewCell.reusableIdentifier)
        
        mainView.splashCollectionView.collectionViewLayout = collectionViewLayout()
        
        // 서버 통신이 끝나기전에 뒤로가기나 그런 것들을 못하게 후에 true로 또는 지금 쓰는 것처럼 로딩
//        view.isUserInteractionEnabled = false
        
    }
    
    @objc func selectButtonClicked() {
//        NotificationCenter.default.post(name: .splashImage, object: nil, userInfo: ["image": postSplashImage ?? ""])
        guard let selectImage = selectImage else {
            // Alert 띄우기
            return
        }

        delegate?.sendImageData(image: selectImage)
        navigationController?.popViewController(animated: true)
    }
    

}

extension SelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionViewCell.reusableIdentifier, for: indexPath) as? SelectCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.borderColor = selectIndexPath == indexPath ? UIColor.red.cgColor : nil
        cell.layer.borderWidth = selectIndexPath == indexPath ? 4 : 0
        cell.splashImageView.kf.setImage(with: URL(string: imageList[indexPath.item]))
        
        return cell
    }
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width / 3) - ((layout.minimumInteritemSpacing * 3) - (spacing * 2))
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        postSplashImage = imageList[indexPath.item]
        print(#function)
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectCollectionViewCell else {return}
        
        selectImage = cell.splashImageView.image
        
        selectIndexPath = indexPath
        collectionView.reloadData()
    }
    
    // 해결해야함
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#function)
        selectIndexPath = nil
        selectImage = nil
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension SelectViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item && pageCount < (totalPage ?? 2) {
                hud.show(in: mainView)
                
                pageCount += 1
                
                RequestAPIManager.shared.requestSplash(page: pageCount, query: mainView.splashSearchBar.text ?? "snack") { list, total in
                    self.imageList.append(contentsOf: list)
                    self.totalPage = total
                    
                    DispatchQueue.main.async {
                        self.mainView.splashCollectionView.reloadData()
                        self.hud.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}

extension SelectViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            
            hud.show(in: mainView)
            
            imageList.removeAll()
            
            RequestAPIManager.shared.requestSplash(page: pageCount, query: text) { list, total in
                self.imageList = list
                self.totalPage = total
                
                DispatchQueue.main.async {
                    self.mainView.splashCollectionView.reloadData()
                    self.hud.dismiss(animated: true)
                }
            }
    
        }

        mainView.endEditing(true)
    }
}
