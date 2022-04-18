//
//  DetailProfileProjectTableViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/11.
//

import UIKit

class DetailProfileProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
