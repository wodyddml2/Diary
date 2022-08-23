import UIKit

import RealmSwift


// UserDiary: 테이블 이름
// @persisted: Column
class UserDairy: Object {
    @Persisted var diaryTitle: String // 제목(필수)
    @Persisted var diaryContent: String?
    @Persisted var diaryWriteDate = Date()
    @Persisted var diaryRegisterDate = Date()
    @Persisted var diaryFavorite: Bool
    @Persisted var diaryImage: String?
    
    // PK: Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId

    convenience init(diaryTitle: String, diaryContent: String?, diaryWriteDate: Date, diaryRegisterDate: Date, diaryImage: String?) {
            self.init()
            self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryWriteDate = diaryWriteDate
        self.diaryRegisterDate = diaryRegisterDate
        self.diaryFavorite = false
        self.diaryImage = diaryImage
    }
}

