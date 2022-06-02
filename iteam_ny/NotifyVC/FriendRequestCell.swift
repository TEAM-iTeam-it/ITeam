//
//  FriendRequestCell.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/05/09.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var AcceptedBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    
    var accept : (() -> ()) = {}
    var refuse : (() -> ()) = {}
    

    @IBAction func clickedAccept(_ sender: Any) {
        accept()
    }
    @IBAction func clickedRefuse(_ sender: Any) {
        refuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
