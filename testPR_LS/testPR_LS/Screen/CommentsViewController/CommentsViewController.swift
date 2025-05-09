import UIKit

//MARK: - CommentsViewController
final class CommentsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let postId: Int
    private var coments: Comments = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(postId: Int) {
        self.postId = postId
        super.init(nibName: "CommentsViewController", bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private
private extension CommentsViewController {
    func setup() {
        view.backgroundColor = Colors.main
        setNavigationController()
        setTabelView()
    }
    
    func setNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Strings.Comments(String(0))
    }
    
    func setTabelView() {
        tableView.register(
            UINib(nibName: СontentTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: СontentTableViewCell.identifier
        )
        
        tableView.backgroundColor = Colors.main
        LoaderView.showLoader(at: self.view, with: Strings.loading)
        DataManager.shared.getComments(postId: postId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coments):
                self.coments = coments
                DispatchQueue.main.async {
                    self.navigationItem.title = Strings.Comments(String(coments.count))
                    self.tableView.reloadData()
                    LoaderView.hideLoader(for: self.view)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coments.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: СontentTableViewCell.identifier,
                                 for: indexPath) as? СontentTableViewCell
        else {
            return UITableViewCell()
        }
        
        let coment = coments[indexPath.row]
        cell.config(title: coment.email, text: coment.body)
        return cell
    }
}
