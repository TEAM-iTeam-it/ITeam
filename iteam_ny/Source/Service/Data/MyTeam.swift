//
//  MyTeam.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/05/17.
//

import Foundation

class MyTeam {
    var name: String
    var profileImg: String
    var part: String
    var uid: String

    //var profileImg: UIImage

    init(uid: String, part: String, name: String, profileImg: String ) {
        self.part = part
        self.name = name
        self.profileImg = profileImg
        self.uid = uid
    }


}
