import Foundation

// MARK: - Post
struct Post: Codable {
    let userId, id: Int
    let title, body: String
}

typealias Posts = [Post]
