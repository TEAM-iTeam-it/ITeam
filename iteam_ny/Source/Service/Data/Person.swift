//
//  Person.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import Foundation
import UIKit

class Person {
    var nickname: String
    var position: String
    var callStm: String
    var profileImg: String
    
    //var profileImg: UIImage
    
    init(nickname: String, position: String, callStm: String, profileImg: String ) {
        self.nickname = nickname
        self.position = position
        self.callStm = callStm
        self.profileImg = profileImg
        //self.profileImg = profileImg
    }
    
    
}
