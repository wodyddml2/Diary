import UIKit

class SearchTableViewCell: BaseTableViewCell {

    let label: UILabel = {
        let view = UILabel()
        
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func configureUI() {
        self.addSubview(label)
    }
   
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(10)
        }
    }

}
