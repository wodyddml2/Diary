import UIKit
import SnapKit
import RealmSwift // 1

class HomeViewController: BaseViewController {

    let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
        if oldSchemaVersion < 1 {
            migration.enumerateObjects(ofType: UserDairy.className()) { oldObject, newObject in
                
                newObject!["diaryWriteDate"] = "\(oldObject!["diaryWriteDate"] ?? Date())"
            }
        }
    }
 
    lazy var localRealm = try! Realm(configuration: config)
    
    // lazy로 즉시 실행 클로저를 지연시켜 초기화 시점에 메모리를 올려 self를 사용할 수 있게 한다.
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .gray
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // 메타타입으로 UITableViewCell.self는 그 객체의 모든 것을 담는다.
        return view
    }()
    
    var tasks: Results<UserDairy>! {
        didSet {
            // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
            // present, overCurrentContext, overFullScreen > viewWillAppear X
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func configureUI() {
        view.addSubview(tableView)
        
        tableView.backgroundColor  = .white
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Diary"
        navigationItem.backButtonTitle = " "
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        if #available(iOS 14.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "정렬", primaryAction: nil, menu: sortedMenuAction())
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortedAlertAction))
        }
        

    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm()
    }
    
    // MARK: Navigation LeftBarItem ===========================
    // 14 이후
    func sortedMenuAction() -> UIMenu {
        let title = UIAction(title: "제목순", image: UIImage(systemName: "character")) { _ in
            self.tasks = self.localRealm.objects(UserDairy.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        }
        let date = UIAction(title: "날짜순", image: UIImage(systemName: "calendar")) { _ in
            self.tasks = self.localRealm.objects(UserDairy.self).sorted(byKeyPath: "diaryRegisterDate", ascending: true)
        }
        let menu = UIMenu(title: "목록 정렬", options: .displayInline, children: [title, date])
        return menu
    }
    
    // 14 버전 이전
    @objc func sortedAlertAction() {
        let alert = UIAlertController(title: "목록 정렬", message: nil, preferredStyle: .actionSheet)
        
        let title = UIAlertAction(title: "제목순", style: .default) { _ in
            self.tasks = self.localRealm.objects(UserDairy.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        }
        let date = UIAlertAction(title: "날짜순", style: .default) { _ in
            self.tasks = self.localRealm.objects(UserDairy.self).sorted(byKeyPath: "diaryRegisterDate", ascending: true)
        }
        [title, date].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
    // MARK: ====================================================
    
    
    func fetchRealm() {
        // realm filter query, NSPredicate
        // 3. Realm 데이터를 배열에 담기
        // sorted같은 쿼리들이 많다.
       tasks = localRealm.objects(UserDairy.self)
    }
    
    @objc func plusButtonClicked() {
        let vc = MainViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
    }
    
  

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
//        loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.textLabel?.text = tasks[indexPath.row].diaryTitle
        return cell
    }
    // 한 번에 삭제나 cell위치 바꾸는 그런 기능은 editing mode에 있음
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            // realm data update
            try! self.localRealm.write{
                // 하나의 레코드에서 특정 컬럼 하나만 변경
                self.tasks[indexPath.row].diaryFavorite = !self.tasks[indexPath.row].diaryFavorite

                // 하나의 테이블에 특정 컬럼 전체 값을 변경
//                self.tasks.setValue(true, forKey: "diaryFavorite")
                // 하나의 레코드에서 여러 컬럼을 변경
//                self.localRealm.create(UserDairy.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 텍스트", "diaryTitle": "변경 제목"], update: .modified)
            }
            // 1. 스와이프한 셀 하나만 ReloadRows 코드 => 상대적 효율성
            // 2. 데이터가 변경됐으니 다시 realm에서 데이터를 가지고 오기 => 위의 didSet으로 일관적 형태로 갱신 할 수 있음
            // 둘 중에 하나
            self.fetchRealm()
        }
        // ACID 데이터베이스 트랜잭션이 안전하게 수행된다는 것을 보장하기 위한 성질을 가리키는 약어 공부
        // 수많은 데이터 중에 키 값이 동일할 경우 안전하게 수행시키기 위한 장치(?)
        // realm 데이터 기준
        let image = tasks[indexPath.row].diaryFavorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .darkGray
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            try! self.localRealm.write {
                self.localRealm.delete(self.tasks[indexPath.row])
            }
            self.fetchRealm()
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
