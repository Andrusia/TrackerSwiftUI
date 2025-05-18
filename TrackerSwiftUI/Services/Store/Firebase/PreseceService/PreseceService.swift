import FirebaseDatabase

class PreseceService {
    let realTimeDB = Database.database().reference()

    func setUserOnlineStatus(uid: String, isOnline: Bool) {
        let statusRef = realTimeDB.child("users/\(uid)/status")
        statusRef.setValue(isOnline ? "online" : "offline")
    }

    func observeUserStatus(uid: String, completion: @escaping (String) -> Void) {
        let statusRef = realTimeDB.child("users/\(uid)/status")
        statusRef.observe(.value) { snapshot in
            if let status = snapshot.value as? String {
                completion(status)
            }
        }
    }
}
