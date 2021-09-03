import UIKit
class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var trainingNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
