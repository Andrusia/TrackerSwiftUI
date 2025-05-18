import Foundation
import UIKit

protocol StorageServiceProtocol {
    func uploadAvatar(uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
}
