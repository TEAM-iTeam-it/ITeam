//
//  TeamProfileTeamMemberTableViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/19.
//

import UIKit

class TeamProfileTeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
