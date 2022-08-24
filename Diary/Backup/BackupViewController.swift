import UIKit

import SnapKit

class BackupViewController: BaseViewController {

    lazy var tableView: UITableView = {
       let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(BackupTableViewCell.self, forCellReuseIdentifier: BackupTableViewCell.reusableIdentifier)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func configureUI() {
        view.addSubview(tableView)
        
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        let recoveryButton = UIBarButtonItem(title: "복구", style: .plain, target: self, action: #selector(recoveryButtonClicked))
        
        navigationItem.rightBarButtonItems = [backupButton,recoveryButton]
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func backupButtonClicked() {
        
    }
    
    @objc private func recoveryButtonClicked() {
        
    }

}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupTableViewCell.reusableIdentifier) as? BackupTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}
