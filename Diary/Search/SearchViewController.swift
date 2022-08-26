import UIKit

import SnapKit
import RealmSwift

enum SearchBarScope: Int {
    case first
    case second
    case third
    
    var result: String {
        switch self {
        case .first:
            return "일기"
        case .second:
            return "과제"
        case .third:
            return "애플"
        }
    }
}

class SearchViewController: BaseViewController {

    private lazy var tableView: UITableView = {
       let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusableIdentifier)
        return view
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    let repository = UserDairyRepository()
  
    var diaryTitleList: [String]?
    var filterList: [String]?
    
  override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryTitleList = repository.fetch().map({
              $0.diaryTitle
          })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    override func configureUI() {
        tableView.rowHeight = 100
       
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = [SearchBarScope.first.result,SearchBarScope.second.result,SearchBarScope.third.result]
        
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
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
        return filterList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reusableIdentifier, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}

        cell.diaryTitleLabel.text = filterList?[indexPath.row]
        repository.fetch().forEach {
            if $0.diaryTitle == filterList?[indexPath.row] {
                cell.diaryDateLabel.text = $0.diaryWriteDate
                cell.diaryImageView.image = loadImageFromDocument(fileName: "\($0.objectId).jpg")
            }
        }
            
        
        
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else {return}
  
        filterList = diaryTitleList?.filter({
            $0.lowercased().contains(text)
        })
     
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case SearchBarScope.first.rawValue: searchBar.text = SearchBarScope.first.result
        case SearchBarScope.second.rawValue: searchBar.text = SearchBarScope.second.result
        case SearchBarScope.third.rawValue: searchBar.text = SearchBarScope.third.result
        default: searchBar.text = ""
        }
    }
}
