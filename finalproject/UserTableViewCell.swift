import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}
