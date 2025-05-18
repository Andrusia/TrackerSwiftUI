import FirebaseStorage

class StorageService: StorageServiceProtocol {
    let storage = Storage.storage()

    func uploadAvatar(uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "StorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
            return
        }

        let storageRef = storage.reference().child("avatars/\(uid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }


}



