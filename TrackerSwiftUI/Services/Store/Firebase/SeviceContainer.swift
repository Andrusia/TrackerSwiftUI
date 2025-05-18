import Foundation

final class ServiceContainer {
    static let shared = ServiceContainer()

    let authService: AuthService
    let firestoreService: FirestoreService
    let storageService: StorageService
    let preseceService: PreseceService

    private init() {
        self.authService = AuthService()
        self.firestoreService = FirestoreService()
        self.storageService = StorageService()
        self.preseceService = PreseceService()
    }
}
