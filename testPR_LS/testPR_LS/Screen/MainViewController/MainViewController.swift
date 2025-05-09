import UIKit

//MARK: - MainViewController
final class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var posts: Posts = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUser()
        getPosts()
    }

}

// MARK: - Private
private extension MainViewController {
    func setup() {
        view.backgroundColor = Colors.main
        setNavigationController()
        getUser()
        setTabelView()
        getPosts()
    }
    
    func setNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Strings.name
        
        let button = UIButton(type: .system)
        let image = Images.user.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Colors.text
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        button.addTarget(self, action: #selector(goToAllUsers), for: .touchUpInside)
        
        let container = UIView()
        container.addSubview(button)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24),
            
            container.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: container)
    }
    
    func getUser() {
        LoaderView.showLoader(at: self.view, with: Strings.loading)
        DataManager.shared.getUser(id: DataManager.shared.userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.navigationItem.title = user.name
                    LoaderView.hideLoader(for: self.view)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setTabelView() {
        tableView.register(
            UINib(nibName: СontentTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: СontentTableViewCell.identifier
        )
       
        tableView.backgroundColor = Colors.main
    }
    
    func getPosts() {
        LoaderView.showLoader(at: self.view, with: Strings.loading)

        DataManager.shared.getPosts(userId: DataManager.shared.userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
                DispatchQueue.main.async {
                    LoaderView.hideLoader(for: self.view)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: СontentTableViewCell.identifier,
                                 for: indexPath) as? СontentTableViewCell
        else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.config(title: post.title, text: post.body, id: post.id, delegate: self)
        return cell
    }
}

//MARK: - ContentTableViewCellDelegate
extension MainViewController: ContentTableViewCellDelegate {
    func touch(id: Int) {
        NavigationService.shared.showCommentsViewController(for: id)
    }
}

//MARK: - Action
private extension MainViewController {
    @objc func goToAllUsers() {
        NavigationService.shared.showUsersViewController()
    }
}
