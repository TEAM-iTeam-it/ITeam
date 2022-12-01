//
//  TeamPlustDate.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/31.
//

import Foundation

class TeamPlusDate{
    var teamName: String
    var purpose: String
    var part: String
    var images: [String]
    var createDate: String
    
    init(teamName: String, purpose: String, part: String, images: [String], createDate: String){
        self.teamName = teamName
        self.purpose = purpose
        self.part = part
        self.images = images
        self.createDate = createDate
        
    }
}
