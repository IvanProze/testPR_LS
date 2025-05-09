import UIKit

//MARK: - ContentTableViewCellDelegate
protocol ContentTableViewCellDelegate {
    func touch(id: Int)
}

//MARK: - СontentTableViewCell
final class СontentTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainTextLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!
    
    private var id: Int?
    private var delegate: ContentTableViewCellDelegate?
    public static let identifier = "СontentTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        mainTextLabel.text = nil
        delegate = nil
    }
}

//MARK: - Public
extension СontentTableViewCell {
    public func config(title: String, text: String, id: Int? = nil, delegate: ContentTableViewCellDelegate? = nil) {
        titleLabel.text = title
        mainTextLabel.text = text
        guard delegate != nil && id != nil else { return }
        self.delegate = delegate
        self.id = id
    }
}

//MARK: - Private
private extension СontentTableViewCell {
    func setup() {
        backgroundView?.backgroundColor = Colors.main
        borderView.backgroundColor = Colors.secondMain
        setLabels()
    }
    
    func setLabels() {
        titleLabel.textColor = Colors.text
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        mainTextLabel.textColor = Colors.subText
        mainTextLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
}

//MARK: - Action
private extension СontentTableViewCell {
    @IBAction func touchAction(_ sender: Any) {
        delegate?.touch(id: id ?? -1)
    }
}
