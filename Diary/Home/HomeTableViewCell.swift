import UIKit

final class HomeTableViewCell: BaseTableViewCell {
    let diaryTitleLabel: UILabel = {
       let view = UILabel()
        view.font = .boldSystemFont(ofSize: 22)
        return view
    }()
    let diaryDateLabel: UILabel = {
        let view = UILabel()
      
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    let diaryImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .black
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [diaryImageView,diaryTitleLabel,diaryDateLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        diaryImageView.snp.makeConstraints { make in
            make.trailing.equalTo(-8)
            make.centerY.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.height.equalTo(diaryImageView.snp.width).multipliedBy(1)
        }

        diaryTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalTo(self).offset(-20)
            make.trailing.lessThanOrEqualTo(diaryImageView.snp.leading).offset(-8)
        
        }
        diaryDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalTo(self).offset(20)
        }
    }
    
}
