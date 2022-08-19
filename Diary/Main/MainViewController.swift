import UIKit

class MainViewController: BaseViewController {

    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureUI() {
        navigationItem.title = "Diary"
        navigationItem.backButtonTitle = " "
        
        mainView.mainToSelectButton.addTarget(self, action: #selector(mainToSelectButtonClicked), for: .touchUpInside)
    }
    
    @objc func mainToSelectButtonClicked() {
        let vc = SelectViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


}
