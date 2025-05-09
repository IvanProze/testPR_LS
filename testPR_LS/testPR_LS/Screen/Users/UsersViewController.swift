import UIKit

//MARK: - UsersViewController
final class UsersViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var users: Users = []
    
    init() {
        super.init(nibName: "UsersViewController", bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - Private
private extension UsersViewController {
    func setup() {
        setNavigationController()
        getUser()
        setTabelView()
    }
    
    func setNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Strings.name
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
            UINib(nibName: UsersTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: UsersTableViewCell.identifier
        )
        
        tableView.backgroundColor = Colors.main
        LoaderView.showLoader(at: self.view, with: Strings.loading)
        DataManager.shared.getUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    LoaderView.hideLoader(for: self.view)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier,
                                 for: indexPath) as? UsersTableViewCell
        else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        let title = "\(user.name) (\(user.username))"
        cell.config(title: title, id: user.id, delegate: self)
        return cell
    }
}

//MARK: - UsersTableViewCellDelegate
extension UsersViewController: UsersTableViewCellDelegate {
    func setUser(id: Int) {
        DataManager.shared.userId = id
        NavigationService.shared.goToBake()
    }
}
