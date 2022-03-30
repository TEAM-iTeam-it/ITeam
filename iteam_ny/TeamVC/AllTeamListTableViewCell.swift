//
//  AllTeamListTableViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit

class AllTeamListTableViewCell: UITableViewCell {


    @IBOutlet weak var teamProfileLabel: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var part: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
