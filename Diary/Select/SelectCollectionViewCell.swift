import UIKit

class SelectCollectionViewCell: BaseCollectionViewCell {
    let splashImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(splashImageView)
    }
    
    override func setConstraints() {
        splashImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
}
