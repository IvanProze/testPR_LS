
import Foundation

// MARK: - Completion Handlers
typealias UsersCompletion = (Result<Users, Error>) -> Void
typealias UserCompletion = (Result<User, Error>) -> Void

typealias PostsCompletion = (Result<Posts, Error>) -> Void
typealias PostCompletion = (Result<Post, Error>) -> Void

typealias CommentsCompletion = (Result<Comments, Error>) -> Void
typealias CommentCompletion = (Result<Comment, Error>) -> Void

// MARK: - JSONPlaceholderEndpoint
enum JSONPlaceholderEndpoint {
    case getUsers(id: Int?)
    case getPosts(userId: Int?)
    case getComments(postId: Int?)

    private var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    private var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getPosts:
            return "/posts"
        case .getComments:
            return "/comments"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .getUsers(let id):
            guard let id = id else { return nil }
            return [URLQueryItem(name: "id", value: String(id))]

        case .getPosts(let userId):
            guard let uid = userId else { return nil }
            return [URLQueryItem(name: "userId", value: String(uid))]

        case .getComments(let postId):
            guard let pid = postId else { return nil }
            return [URLQueryItem(name: "postId", value: String(pid))]
        }
    }

    var request: URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems

        let url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

// MARK: - APIManagerJSONPlaceholder
final class APIManagerJSONPlaceholder {
    static public let shared = APIManagerJSONPlaceholder()
    init() {}
    private let decoder = JSONDecoder()
    
    //MARK: - Users
    func fetchUsers(id: Int? = nil, completion: @escaping UsersCompletion) {
        let endpoint = JSONPlaceholderEndpoint.getUsers(id: id)
        let request  = endpoint.request

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(err)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            do {
                let users = try self.decoder.decode(Users.self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchUser(id: Int, completion: @escaping UserCompletion) {
        let endpoint = JSONPlaceholderEndpoint.getUsers(id: id)
        let request  = endpoint.request
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(err)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1))); return
            }
            do {
                let users = try self.decoder.decode(Users.self, from: data)
                if let user = users.first {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "UserNotFound", code: 404)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    //MARK: - Posts
    func fetchPosts(userId: Int? = nil, completion: @escaping PostsCompletion) {
        let endpoint = JSONPlaceholderEndpoint.getPosts(userId: userId)
        let request  = endpoint.request
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(err)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            do {
                let posts = try self.decoder.decode(Posts.self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    //MARK: - Comments
    func fetchComments(postId: Int? = nil, completion: @escaping CommentsCompletion) {
        let endpoint = JSONPlaceholderEndpoint.getComments(postId: postId)
        let request  = endpoint.request
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(err)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            do {
                let comments = try self.decoder.decode(Comments.self, from: data)
                completion(.success(comments))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
