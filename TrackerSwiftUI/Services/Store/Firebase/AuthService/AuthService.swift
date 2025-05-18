import FirebaseAuth

class AuthService: AuthServiceProtocol {
    let auth = Auth.auth()

    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                completion(.failure(error))
            } else if let uid = authResult?.user.uid {
                completion(.success(uid))
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                completion(.failure(error))
            } else if let uid = authResult?.user.uid {
                completion(.success(uid))
            }
        }
    }

    func logoutUser(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let uid = auth.currentUser?.uid ?? ""
            try auth.signOut()
            completion(.success(uid))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
}



