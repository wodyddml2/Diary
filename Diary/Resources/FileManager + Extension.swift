
import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentDirectory
    }
    
    func ImageDirectoryPath() -> URL? {
        let iamgeDirectory = documentDirectoryPath()?.appendingPathComponent("Image")
        
        return iamgeDirectory
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let imageDirectory = ImageDirectoryPath() else {return}
        
        if FileManager.default.fileExists(atPath: imageDirectory.path) {
            let fileURL = imageDirectory.appendingPathComponent(fileName)// 세부 경로 지정, 이미지를 저장할 위치
            guard let data = image.jpegData(compressionQuality: 0.5) else {return} // 이미지 용량 압축
            print(fileURL)
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("file save error", error)
            }
        } else {
            do {
                try FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true)
            } catch {
                print("경로")
            }
            let fileURL = imageDirectory.appendingPathComponent(fileName)
            guard let data = image.jpegData(compressionQuality: 0.5) else {return}
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("file save error", error)
            }
        }
        
        
    }
    
    // 나중에 테이블셀에 이미지 만들어서 쓰자~
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let imageDirectory = ImageDirectoryPath() else {return nil}
        let fileURL = imageDirectory.appendingPathComponent(fileName)// 세부 경로 지정, 이미지가 저장된 위치
        
        // 이미지가 없을 때 대응 (ex. 영화 포스터 등)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star")
        }

        
    }
    
    
    func fetchDocumentZipFile(completion: @escaping([String], [Double]?) -> ()) {
        do {
            guard let path = documentDirectoryPath() else {return}
            
            // 문서의 파일 전체 목록 가져옴
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
           
            // zip파일만 가져옴
            let zip = docs.filter {
                $0.pathExtension == "zip"
            }
          
            
            let result = zip.map {
                $0.lastPathComponent
            }
            
            let fileSize = zip.map {
                try? FileManager.default.attributesOfItem(atPath: $0.path)[.size]
            } as? [Double]
            
            completion(result, fileSize)
         
            
        } catch {
            print("Error")
        }
    }
}
