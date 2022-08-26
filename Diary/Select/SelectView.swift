import UIKit

final class SelectView: BaseView {
    let splashSearchBar: UISearchBar = {
        let view = UISearchBar()
        
        return view
    }()
    
    let splashCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [splashSearchBar, splashCollectionView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        splashSearchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        splashCollectionView.snp.makeConstraints { make in
            make.top.equalTo(splashSearchBar.snp.bottom)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }

}
