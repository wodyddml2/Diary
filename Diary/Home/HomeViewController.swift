import UIKit

import SnapKit
import RealmSwift
import FSCalendar

class HomeViewController: BaseViewController {

    
    let repository = UserDairyRepository()
    
    lazy var calender: FSCalendar = {
       let view = FSCalendar()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    // lazy로 즉시 실행 클로저를 지연시켜 초기화 시점에 메모리를 올려 self를 사용할 수 있게 한다.
    lazy var tableView: UITableView = {
        let view = UITableView() // 빈괄호로 초기화가 가능한 이유는 nibname 등 매개변수 값이 어차피 nil이기에
        view.backgroundColor = .gray
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reusableIdentifier)
        // 메타타입으로 UITableViewCell.self는 그 객체의 모든 것을 담는다.
        return view
    }()
    
    let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
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
        view.addSubview(calender)
        
        tableView.backgroundColor  = .white
        tableView.rowHeight = 100
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Diary"
        navigationItem.backButtonTitle = " "
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        var sortedButton: UIBarButtonItem
        if #available(iOS 14.0, *) {
            sortedButton = UIBarButtonItem(title: "정렬", primaryAction: nil, menu: sortedMenuAction())
        } else {
            sortedButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortedAlertAction))
        }
        let backupButton = UIBarButtonItem(title: "백업/복구", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortedButton,backupButton]

    }
    
    override func setConstraint() {
        
        calender.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view).multipliedBy(0.3)
        }
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(calender.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm()
    }
    
    @objc func backupButtonClicked() {
        let vc = BackupViewController()
        transition(vc, transitionStyle: .push)
    }
    
    // MARK: Navigation LeftBarItem ===========================
    // 14 이후
    func sortedMenuAction() -> UIMenu {
        let title = UIAction(title: "제목순", image: UIImage(systemName: "character")) { _ in
            self.tasks = self.repository.fetchSort("diaryTitle")
        }
        let date = UIAction(title: "날짜순", image: UIImage(systemName: "calendar")) { _ in
            self.tasks = self.repository.fetchSort("diaryRegisterDate")
        }
        let menu = UIMenu(title: "목록 정렬", options: .displayInline, children: [title, date])
        return menu
    }
    
    // 14 버전 이전
    @objc func sortedAlertAction() {
        let alert = UIAlertController(title: "목록 정렬", message: nil, preferredStyle: .actionSheet)
        
        let title = UIAlertAction(title: "제목순", style: .default) { _ in
            self.tasks = self.repository.fetchSort("diaryTitle")
        }
        let date = UIAlertAction(title: "날짜순", style: .default) { _ in
            self.tasks = self.repository.fetchSort("diaryRegisterDate")
        }
        [title, date].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
    // MARK: ====================================================
    
    
    func fetchRealm() {
       
        tasks = repository.fetch()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reusableIdentifier) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.diaryTitleLabel.text = tasks[indexPath.row].diaryTitle
        cell.diaryDateLabel.text = tasks[indexPath.row].diaryWriteDate
        return cell
    }
    // 한 번에 삭제나 cell위치 바꾸는 그런 기능은 editing mode에 있음
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            // realm data update
//            try! self.repository.localRealm.write{
                // 하나의 레코드에서 특정 컬럼 하나만 변경
//                self.tasks[indexPath.row].diaryFavorite = !self.tasks[indexPath.row].diaryFavorite
                // 하나의 테이블에 특정 컬럼 전체 값을 변경
//                self.tasks.setValue(true, forKey: "diaryFavorite")
                // 하나의 레코드에서 여러 컬럼을 변경
//                self.localRealm.create(UserDairy.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 텍스트", "diaryTitle": "변경 제목"], update: .modified)
//            }
            self.repository.updateFavorite(item: self.tasks[indexPath.row])
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
            // 데이터의 정합성을 위해 인스턴스 생성해서 하나로 담아둔다, 이유는 아래의 순서일 때 이미지 삭제시 해당 레코드의 인덱스를 찾지 못한다. 임의로 인스턴스를 생성해서 담아놓으면 렘이 삭제되어도 인스턴스는 살아있기에 이미지마저 잘 삭제가 된다.: 근데 나 왜 안될까?
            let task = self.tasks[indexPath.row]
            self.repository.deleteRecord(item: task)
            
            self.fetchRealm()
//            tableView.beginUpdates()
//            tableView.endUpdates()
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

extension HomeViewController : FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetchDate(date: date).count
    }
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "SeSAC"
//    }
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        <#code#>
//    }
    // date: yyyyMMdd hh:mm:ss => dateFormatter
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return formatter.string(from: date) == "220907" ? "오프라인 모임" : nil
    }
    // 100개중 -> 25일 3개 -> 3개만 cell
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
    }
}
