import UIKit

class SearchViewController: BaseViewController {

    private lazy var tableView: UITableView = {
       let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reusableIdentifier)
        return view
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureUI() {
        
        navigationItem.searchController = searchController
        searchController.view.addSubview(tableView)
    }

    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalTo(searchController.view.safeAreaLayoutGuide)
        }
    }
   

}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reusableIdentifier, for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        cell.label.text = "Sss"
        return cell
    }
    
    
}
