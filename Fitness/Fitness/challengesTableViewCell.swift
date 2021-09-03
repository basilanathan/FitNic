//
//  challengesTableViewCell.swift
//  Fitnic

import UIKit

class challengesTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imgLevelThumb: UIImageView!
    @IBOutlet weak var lblLevelName: UILabel!
    @IBOutlet weak var imgLock: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
