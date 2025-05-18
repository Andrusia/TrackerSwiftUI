import Foundation

struct UserProfile: Codable, Identifiable {
    let id = UUID()
    let uid: String
    let name: String
    let email: String
    var subscriptions: [String] = []
    var avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case uid, name, email, subscriptions, avatarURL
    }
}
