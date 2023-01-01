//
//  RequestTableViewCell.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit

class RequestTableViewCell: UITableViewCell {


    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var callStateBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

