import Foundation
import RealmSwift

// MARK: - DataManager
final class DataManager {
    static let shared = DataManager()
    private init() {}
    
    // MARK: – UserDefaults Keys
    private let launchKey = "launchCount"
    private let userIdKey = "DataManager.userId"
    
    var launchCount: Int {
        UserDefaults.standard.integer(forKey: launchKey)
    }
    
    var userId: Int {
        get {
            guard
                let data = UserDefaults.standard.data(forKey: userIdKey),
                let value = try? JSONDecoder().decode(Int.self, from: data)
            else {
                return -1
            }
            return value
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: userIdKey)
            }
        }
    }
}

// MARK: - Public
extension DataManager {
    public func incrementLaunchCount() {
        let newCount = launchCount + 1
        UserDefaults.standard.set(newCount, forKey: launchKey)
    }

    // MARK: – Users
    public func getUsers(
        id: Int? = nil,
        completion: @escaping UsersCompletion
    ) {
        let realm = try! Realm()
        let isOnline = NetworkMonitor.shared.isConnected

        if !isOnline {
            if let id = id {
                if let obj = realm.object(ofType: UserObject.self, forPrimaryKey: id) {
                    completion(.success([obj.toUser()]))
                } else {
                    completion(.failure(NSError(domain: "DataManager",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Offline and no cached user"])))
                }
            } else {
                let objects = realm.objects(UserObject.self)
                if !objects.isEmpty {
                    completion(.success(objects.map { $0.toUser() }))
                } else {
                    completion(.failure(NSError(domain: "DataManager",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Offline and no cached users"])))
                }
            }
            return
        }

        APIManagerJSONPlaceholder.shared.fetchUsers(id: id) { result in
            switch result {
            case .success(let users):
                let realm = try! Realm()
                try? realm.write {
                    let objs = users.map { UserObject(from: $0) }
                    realm.add(objs, update: .modified)
                }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func getUser(
        id: Int,
        completion: @escaping UserCompletion
    ) {
        let realm = try! Realm()
        let isOnline = NetworkMonitor.shared.isConnected

        if !isOnline {
            if let obj = realm.object(ofType: UserObject.self, forPrimaryKey: id) {
                completion(.success(obj.toUser()))
            } else {
                completion(.failure(NSError(domain: "DataManager",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Offline and no cached user"])))
            }
            return
        }

        APIManagerJSONPlaceholder.shared.fetchUser(id: id) { result in
            switch result {
            case .success(let user):
                let realm = try! Realm()
                try? realm.write {
                    realm.add(UserObject(from: user), update: .modified)
                }
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: – Posts
    public func getPosts(
        userId: Int? = nil,
        completion: @escaping PostsCompletion
    ) {
        let realm = try! Realm()
        let isOnline = NetworkMonitor.shared.isConnected

        if !isOnline {
            let objects = userId != nil
                ? realm.objects(PostObject.self).filter("userId == %@", userId!)
                : realm.objects(PostObject.self)
            if !objects.isEmpty {
                completion(.success(objects.map { $0.toPost() }))
            } else {
                completion(.failure(NSError(domain: "DataManager",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Offline and no cached posts"])))
            }
            return
        }

        APIManagerJSONPlaceholder.shared.fetchPosts(userId: userId) { result in
            switch result {
            case .success(let posts):
                let realm = try! Realm()
                try? realm.write {
                    let objs = posts.map { PostObject(from: $0) }
                    realm.add(objs, update: .modified)
                }
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: – Comments
    public func getComments(
        postId: Int? = nil,
        completion: @escaping CommentsCompletion
    ) {
        let realm = try! Realm()
        let isOnline = NetworkMonitor.shared.isConnected

        if !isOnline {
            let objects = postId != nil
                ? realm.objects(CommentObject.self).filter("postId == %@", postId!)
                : realm.objects(CommentObject.self)
            if !objects.isEmpty {
                completion(.success(objects.map { $0.toComment() }))
            } else {
                completion(.failure(NSError(domain: "DataManager",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Offline and no cached comments"])))
            }
            return
        }

        APIManagerJSONPlaceholder.shared.fetchComments(postId: postId) { result in
            switch result {
            case .success(let comments):
                let realm = try! Realm()
                try? realm.write {
                    let objs = comments.map { CommentObject(from: $0) }
                    realm.add(objs, update: .modified)
                }
                completion(.success(comments))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
