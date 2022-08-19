import UIKit

import Kingfisher

class SelectViewController: BaseViewController {
    let mainView = SelectView()
    
    var pageCount = 1
    
    var imageList: [String] = []
    var totalPage: Int?
    
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
    }
    
    @objc func selectButtonClicked() {
        
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
    
}

extension SelectViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item && pageCount < (totalPage ?? 2) {
                pageCount += 1
                RequestAPIManager.shared.requestSplash(page: pageCount, query: mainView.splashSearchBar.text ?? "snack") { list, total in
                    self.imageList.append(contentsOf: list)
                    self.totalPage = total
                    
                    DispatchQueue.main.async {
                        self.mainView.splashCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension SelectViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            
            imageList.removeAll()
            
            RequestAPIManager.shared.requestSplash(page: pageCount, query: text) { list, total in
                self.imageList = list
                self.totalPage = total
                
                DispatchQueue.main.async {
                    self.mainView.splashCollectionView.reloadData()
                }
            }
    
        }

        mainView.endEditing(true)
    }
}
