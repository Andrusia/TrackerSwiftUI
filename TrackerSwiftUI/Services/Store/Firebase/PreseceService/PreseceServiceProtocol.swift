import Foundation

protocol PreseceServiceProtocol {
    func setUserOnlineStatus(uid: String, isOnline: Bool)
    func observeUserStatus(uid: String, completion: @escaping (String) -> Void)
}

