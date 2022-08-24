
import UIKit

extension UIViewController {
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName)// 세부 경로 지정, 이미지를 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else {return} // 이미지 용량 압축
        print(fileURL)
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
    
    // 나중에 테이블셀에 이미지 만들어서 쓰자~
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName)// 세부 경로 지정, 이미지가 저장된 위치
        
        // 이미지가 없을 때 대응 (ex. 영화 포스터 등)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star")
        }
//        let image = UIImage(contentsOfFile: fileURL.path)
//
//        return image
        
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName)// 세부 경로 지정, 이미지가 저장된 위치
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
