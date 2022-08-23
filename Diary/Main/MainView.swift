import UIKit

class MainView: BaseView {
    let mainImageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let firstTextField: UITextField = {
        let view = DiaryTextField()
        view.placeholder = "제목을 입력해주세요!"
        return view
    }()
    
    let secondTextField: UITextField = {
        let view = DiaryTextField()
        view.placeholder = "날짜를 입력해주세요!"
        return view
    }()
    
    let mainTextView: UITextView = {
        let view = UITextView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let mainToSelectButton: UIButton = {
        let view = UIButton()
        view.setTitle("Select", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let sampleButton: UIButton = {
       let view = UIButton()
        view.backgroundColor = .blue
        return view
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mainImageView, firstTextField, secondTextField, mainTextView, mainToSelectButton, sampleButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.height.equalTo(UIScreen.main.bounds.height / 4.5)
        }
        
        firstTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(mainImageView.snp.bottom).offset(12)
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo((UIScreen.main.bounds.height / 5.5) / 4)
        }
        
        secondTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(firstTextField.snp.bottom).offset(12)
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo((UIScreen.main.bounds.height / 5.5) / 4)
        }
        
        mainTextView.snp.makeConstraints { make in
            make.top.equalTo(secondTextField.snp.bottom).offset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(mainImageView.snp.width)
            make.centerX.equalTo(self)
        }
        
        mainToSelectButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(mainImageView).offset(-8)
        }
        
        sampleButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.trailing.top.equalTo(self.safeAreaLayoutGuide)
        }
    }

}
