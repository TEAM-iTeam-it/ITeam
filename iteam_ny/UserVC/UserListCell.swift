 //
//  UserListCell.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/03/08.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var userPurpose: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //print("MyTableViewCell - awakeFromNib() called")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //print("클릭")
        // Configure the view for the selected state
    }
    
}
