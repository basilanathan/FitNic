//  thirtydayCollectionviewCell.swift
//  Fitnic

import UIKit
class thirtydayCollectionviewCell: UICollectionViewCell {
    @IBOutlet weak var lblChallengeDay: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblChallengeDay.layer.cornerRadius = self.lblChallengeDay.frame.size.width/2
        self.lblChallengeDay.layer.borderWidth = 2.0
        self.lblChallengeDay.layer.masksToBounds = true

        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            self.lblChallengeDay.font = UIFont(name: (self.lblChallengeDay.font?.fontName)!, size: 26.0)
        } else {
            self.lblChallengeDay.font = UIFont(name: (self.lblChallengeDay.font?.fontName)!, size: 18.0)
        }
    }
}
