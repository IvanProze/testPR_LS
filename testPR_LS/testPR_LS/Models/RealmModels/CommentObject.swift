import Foundation
import RealmSwift

//MARK: - CommentObject
final class CommentObject: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var postId: Int = 0
    @Persisted var name: String = ""
    @Persisted var email: String = ""
    @Persisted var body: String = ""
    
    convenience init(from comment: Comment) {
        self.init()
        self.id = comment.id
        self.postId = comment.postId
        self.name = comment.name
        self.email = comment.email
        self.body = comment.body
    }
    
    func toComment() -> Comment {
        return Comment(postId: postId, id: id, name: name, email: email, body: body)
    }
}
