//
//  FixedMemberCell.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/12/05.
//

import UIKit

class FixedMemberCell: UICollectionViewCell{
    
    @IBOutlet weak var memberImage: UIImageView!
    
    @IBOutlet weak var membernameLable: UILabel!
    
    @IBOutlet weak var memberRoleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
