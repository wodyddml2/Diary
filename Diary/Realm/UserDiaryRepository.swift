import Foundation

import RealmSwift

// 여러개의 테이블 => CRUD

protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDairy>
    func fetchSort(_ sort: String) -> Results<UserDairy>
    func fetchDate(date: Date) -> Results<UserDairy>
    func updateFavorite(item: UserDairy)
    func removeImageFromDocument(fileName: String)
}

class UserDairyRepository: UserDiaryRepositoryType {
    func fetchDate(date: Date) -> Results<UserDairy> {
        
        return localRealm.objects(UserDairy.self).filter("diaryRegisterDate >= %@ AND diaryRegisterDate < %@", date, Date(timeInterval: 86400, since: date))
    }
    
    let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
        if oldSchemaVersion < 1 {
            migration.enumerateObjects(ofType: UserDairy.className()) { oldObject, newObject in
                
                newObject!["diaryWriteDate"] = "\(oldObject!["diaryWriteDate"] ?? Date())"
            }
        }
    }
  
    lazy var localRealm = try! Realm(configuration: config) // 내부에서 구조적으로 한 곳을 가리키고 있기 때문에 싱글턴 패턴을 해줄 필요는 없고 여러 곳에서 다 인스턴스 생성을 안해줘도 된다. 또한 struct 구조로 되어있다고 한다.
    
    func fetch() -> Results<UserDairy> {
        
       return localRealm.objects(UserDairy.self)
    }
    func fetchSort(_ sort: String) -> Results<UserDairy> {
        return localRealm.objects(UserDairy.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func updateFavorite(item: UserDairy) {
        try! localRealm.write{
            // 하나의 레코드에서 특정 컬럼 하나만 변경
//            tasks[index].diaryFavorite = !tasks[index].diaryFavorite
            
            item.diaryFavorite.toggle()
            
        }
    }
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        } //Document 경로
        let imageDirectory = documentDirectory.appendingPathComponent("Image")
        let fileURL = imageDirectory.appendingPathComponent(fileName)// 세부 경로 지정, 이미지가 저장된 위치
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
    func deleteRecord(item: UserDairy) {
        removeImageFromDocument(fileName: "\(item.objectId).jpg")
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
}
