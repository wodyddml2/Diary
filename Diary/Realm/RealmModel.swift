import UIKit

import RealmSwift


// UserDiary: 테이블 이름
// @persisted: Column
class UserDairy: Object {
    @Persisted var diaryTitle: String
    @Persisted var diaryContent: String?
    @Persisted var diaryWriteDate: String?
    @Persisted var diaryRegisterDate = Date()
    @Persisted var diaryFavorite: Bool
    @Persisted var diaryImage: String?
    
    
    // PK: Int, UUID, ObjectID (String도 있으나 거의 사용하지 않는다.)
    @Persisted(primaryKey: true) var objectId: ObjectId

    convenience init(diaryTitle: String, diaryContent: String?, diaryWriteDate: String, diaryRegisterDate: Date, diaryImage: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryWriteDate = diaryWriteDate
        self.diaryRegisterDate = diaryRegisterDate
        self.diaryFavorite = false
        self.diaryImage = diaryImage
    }
}

