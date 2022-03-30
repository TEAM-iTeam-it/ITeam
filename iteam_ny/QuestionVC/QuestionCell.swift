//
//  QuestionCell.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/12/06.
//

import UIKit

class QuesstionCell: UITableViewCell{
    
    @IBOutlet weak var questionLable: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBAction func checkButtonTapped(_ sender: Any) {
      checkButton.isSelected.toggle()
   }
    
    var isCheck: Bool = false {
            didSet {
                let imageName = isCheck ? "circle" : "checkmark.circle.fill"
                checkButton.setImage(UIImage(systemName: imageName), for: .normal)
            }
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            isCheck.toggle()
        }
    
}


