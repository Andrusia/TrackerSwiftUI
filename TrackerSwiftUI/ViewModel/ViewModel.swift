import Foundation
import SwiftUI

func closeKeyboard() {
  UIApplication.shared.sendAction(
    #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
  )
}

enum AppScreen {
    case loading
    case login
    case app
}

enum TabScreen: Int, Hashable, CaseIterable {
    case profile
    case users

    var title: String {
        switch self {
        case .profile:
            return "profile"
        case .users:
            return "users"
        }
    }
}

final class ViewModel: ObservableObject {
    static let shared: ViewModel = .init()

    let firestoreService = ServiceContainer.shared.firestoreService
    let storageService = ServiceContainer.shared.storageService
    let authService = ServiceContainer.shared.authService


    @Published var user: UserProfile?
    @Published var users: [UserProfile] = []
    @Published var errorMessage: String?
    @Published var isPerformingAction: Bool = false
    @Published var currentScreen: AppScreen = .loading
    @Published var currentTabScreen: TabScreen = .users

    var shownErrorMessage: Binding<Bool> {
        return Binding(get: { self.errorMessage != nil }, set: { _ in self.errorMessage = nil })
    }

    private init() {
        checkCurrentUser()
    }

    func checkCurrentUser() {
        if let currentUser = authService.auth.currentUser {
            print("Current user found: \(currentUser.uid)")
            loadUserProfile(uid: currentUser.uid)
            self.loadUserProfile(uid: currentUser.uid)
        } else {
            print("No current user found")
            currentScreen = .login
        }
    }

    func loadUserProfile(uid: String) {
        print("Loading user profile for uid: \(uid)")
        isPerformingAction = true
        firestoreService.getUserData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isPerformingAction = false
                switch result {
                case .success(let userProfile):
                    print("User profile loaded successfully for uid: \(uid)")
                    self.user = userProfile
                    self.currentScreen = .app
                    self.fetchAllUsers()
                    print("Current screen set to app, user: \(String(describing: self.user))")
                case .failure(let error):
                    print("Failed to load user profile for uid: \(uid), error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.currentScreen = .login
                    print("Current screen set to login")
                }
            }
        }
    }

    func fetchAllUsers() {
        firestoreService.fetchAllUsers { [weak self] result in
              guard let self = self else { return }
              DispatchQueue.main.async {
                  switch result {
                  case .success(let users):
                      self.users = users
                  case .failure(let error):
                      self.errorMessage = error.localizedDescription
                  }
              }
          }
      }


    func createUser(email: String, password: String, name: String?) {
        isPerformingAction = true
        print("Creating user with email: \(email)")
        authService.createUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isPerformingAction = false
                switch result {
                case .success(let uid):
                    print("User created successfully with email: \(email)")
                    self.errorMessage = "User created successfully"

                    let userProfile = UserProfile(uid: uid, name: name ?? "", email: email, subscriptions: [])
                    self.firestoreService.saveUserProfile(userProfile: userProfile) { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            print("Save user profile error: \(error.localizedDescription)")
                        } else {
                            print("User profile saved successfully")
                            self.loadUserProfile(uid: uid)
                        }
                    }

                case .failure(let error):
                    print("Failed to create user with email: \(email), error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateUserProfile(name: String? = nil, email: String? = nil, avatarURL: String? = nil) {
          guard var user = user else { return }
          var updateData: [String: Any] = [:]
          if let name = name {
              updateData["name"] = name
          }
          if let email = email {
              updateData["email"] = email
          }
          if let avatarURL = avatarURL {
              updateData["avatarURL"] = avatarURL
              user.avatarURL = avatarURL
          }
          firestoreService.updateUserData(uid: user.uid, data: updateData) { [weak self] result in
              guard let self = self else { return }
              DispatchQueue.main.async {
                  switch result {
                  case .success:
                      self.user = user
                  case .failure(let error):
                      self.errorMessage = error.localizedDescription
                  }
              }
          }
      }
  

    func loginUser(email: String, password: String) {
        isPerformingAction = true
        print("Logging in user with email: \(email)")
        authService.loginUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isPerformingAction = false
                switch result {
                case .success(let uid):
                    print("User logged in successfully with email: \(email)")
                    self.loadUserProfile(uid: uid)
                    ServiceContainer.shared.preseceService.setUserOnlineStatus(uid: uid, isOnline: true)
                case .failure(let error):
                    print("Failed to log in user with email: \(email), error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func logoutUser() {
        print("Logging out user")
        authService.logoutUser { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let uid):
                    print("User logged out successfully")
                    self.currentScreen = .login
                    self.user = nil
                    ServiceContainer.shared.preseceService.setUserOnlineStatus(uid: uid, isOnline: false)
                case .failure(let error):
                    print("Failed to log out user, error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

}

extension ViewModel {
    func uploadAvatar(image: UIImage) {
            guard let user = user else { return }
            isPerformingAction = true

            storageService.uploadAvatar(uid: user.uid, image: image) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isPerformingAction = false
                    switch result {
                    case .success(let url):
                        self.updateUserProfile(avatarURL: url)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }

}
