

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avtImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flLabel: UILabel!
    @IBOutlet weak var gitImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
