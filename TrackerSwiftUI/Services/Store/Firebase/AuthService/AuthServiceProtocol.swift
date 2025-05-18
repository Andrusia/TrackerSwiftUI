import Foundation

protocol AuthServiceProtocol {
    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func logoutUser(completion: @escaping (Result<String, Error>) -> Void)
}



