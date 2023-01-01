//
//  AnswerTableViewCell.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamProfileLabel: UILabel!
    @IBOutlet weak var circleTitleView: GradientView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var callStateBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var sameSchoolLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var callingStateBtn: CallStatementButton!
    @IBOutlet weak var grayImageView: UIView!
    @IBOutlet weak var nicknameToSameSchoolConst: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        callStateBtn.backgroundColor = .clear
        //callStateBtn = UIButton()
    }

}
