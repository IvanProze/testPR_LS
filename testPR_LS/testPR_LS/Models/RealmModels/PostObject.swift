import Foundation
import RealmSwift

//MARK: - PostObject
final class PostObject: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var userId: Int = 0
    @Persisted var title: String = ""
    @Persisted var body: String = ""
    
    convenience init(from post: Post) {
        self.init()
        self.id = post.id
        self.userId = post.userId
        self.title = post.title
        self.body = post.body
    }
    
    func toPost() -> Post {
        return Post(userId: userId, id: id, title: title, body: body)
    }
}
