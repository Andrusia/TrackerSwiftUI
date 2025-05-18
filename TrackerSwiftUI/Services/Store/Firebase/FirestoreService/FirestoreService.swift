import FirebaseFirestore

class FirestoreService: FirestoreServiceProtocol {
    let db = Firestore.firestore()

    func saveUserProfile(_ userProfile: UserProfile, completion: @escaping (Error?) -> Void) {
        do {
            let json = try JSONEncoder().encode(userProfile)
            let data = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
            db.collection("users").document(userProfile.uid).setData(data ?? [:], completion: completion)
        } catch {
            completion(error)
        }
    }

    func getUserData(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Get user data error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let document = document, document.exists, let data = document.data() else {
                let noDocumentError = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
                print("No document error: \(noDocumentError.localizedDescription)")
                completion(.failure(noDocumentError))
                return
            }
            do {
                let userProfile = try self.decodeUserProfile(from: data)
                print("User data retrieved successfully for uid: \(uid)")
                completion(.success(userProfile))
            } catch {
                print("Decode user data error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func updateUserData(uid: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let docRef = db.collection("users").document(uid)
        docRef.updateData(data) { error in
            if let error = error {
                print("Update user data error: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("User data updated successfully for uid: \(uid)")
                completion(.success(()))
            }
        }
    }

    func saveUserProfile(userProfile: UserProfile, completion: @escaping (Error?) -> Void) {
        do {
            let json = try encodeUserProfile(userProfile)
            db.collection("users").document(userProfile.uid).setData(json) { error in
                if let error = error {
                    print("Save user profile error: \(error.localizedDescription)")
                } else {
                    print("User profile saved successfully")
                }
                completion(error)
            }
        } catch {
            print("Save user profile error: \(error.localizedDescription)")
            completion(error)
        }
    }

    func fetchAllUsers(completion: @escaping (Result<[UserProfile], Error>) -> Void) {
        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let users = try querySnapshot?.documents.compactMap { document -> UserProfile? in
                    let data = document.data()
                    return try self.decodeUserProfile(from: data)
                } ?? []
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
    }

}

extension FirestoreService {
    func encodeUserProfile(_ userProfile: UserProfile) throws -> [String: Any] {
        let data = try JSONEncoder().encode(userProfile)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return json ?? [:]
    }

    func decodeUserProfile(from data: [String: Any]) throws -> UserProfile {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        let userProfile = try JSONDecoder().decode(UserProfile.self, from: jsonData)
        return userProfile
    }
}

