import Foundation

protocol FirestoreServiceProtocol {
    func getUserData(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
    func updateUserData(uid: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchAllUsers(completion: @escaping (Result<[UserProfile], Error>) -> Void)
}
