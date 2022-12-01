//
//  QuestionCell.swift
//  iteam_ny
//
//  Created by 성나연 on 2021/12/06.
//

import UIKit

class QuesstionCell: UITableViewCell{
    
//    var delegate: QuesstionCellDelegate?
    @IBOutlet weak var questionLable: UILabel!
    @IBOutlet weak var checkButton: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
}
struct Todo {
    var title: String
    var isMarked: Bool
}

