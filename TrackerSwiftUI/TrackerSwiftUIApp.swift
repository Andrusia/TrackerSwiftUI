import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
//    let serviceContainer = ServiceContainer.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    private func updateOnlineStatus(isOnline: Bool) {
        if let uid = Auth.auth().currentUser?.uid {
            ServiceContainer.shared.preseceService.setUserOnlineStatus(uid: uid, isOnline: isOnline)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        updateOnlineStatus(isOnline: true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateOnlineStatus(isOnline: false)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        updateOnlineStatus(isOnline: false)
    }
}
@main
struct TrackerSwiftUIApp: App {
    @StateObject var viewModel: ViewModel = .shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
       WindowGroup {
           RootView()
               .environmentObject(viewModel)
       }
     }
}
