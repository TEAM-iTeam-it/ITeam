//
//  AddfriendCell.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/11.
//

import UIKit

class AddfriendCell: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var friendProfile: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

