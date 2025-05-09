import Foundation

// MARK: - Comment
struct Comment: Codable {
    let postId, id: Int
    let name, email, body: String
}

typealias Comments = [Comment]
