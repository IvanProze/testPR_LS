import UIKit

//MARK: - UsersTableViewCellDelegate
protocol UsersTableViewCellDelegate {
    func setUser(id: Int)
}

//MARK: - UsersTableViewCell
final class UsersTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!
    
    private var userId: Int?
    private var delegate: UsersTableViewCellDelegate?
    public static let identifier = "UsersTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

//MARK: - Public
extension UsersTableViewCell {
    public func config(title: String, id: Int? = nil, delegate: UsersTableViewCellDelegate ) {
        titleLabel.text = title
        self.delegate = delegate
        self.userId = id
    }
}

//MARK: - Private
private extension UsersTableViewCell {
    func setup() {
        backgroundView?.backgroundColor = Colors.main
        borderView.backgroundColor = Colors.secondMain
        setLabels()
    }
    
    func setLabels() {
        titleLabel.textColor = Colors.text
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
}

//MARK: - Action
extension UsersTableViewCell {
    @IBAction func setUserAction(_ sender: Any) {
        delegate?.setUser(id: userId ?? -1)
    }
}
