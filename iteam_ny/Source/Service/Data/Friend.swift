//
//  Friend.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/12.
//

import Foundation
import UIKit

class Friend {
    var nickname: String
    var position: String
    var profileImg: String
    var uid:String
    var stmt : String
    
    //var profileImg: UIImage
    
    init(uid:String,nickname: String, position: String, profileImg: String , stmt:String ) {
        self.nickname = nickname
        self.uid = uid
        self.position = position
        self.profileImg = profileImg
        self.stmt = stmt
        //self.profileImg = profileImg
    }
    
    
}
