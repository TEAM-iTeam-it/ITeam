//
//  Team.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/29.
//

import Foundation

/*서버로 받아올 팀 리스트*/
class Team{
    var teamName: String
    var purpose: String
    var part: String
    var images: [String]
    
    init(teamName: String, purpose: String, part: String, images: [String]){
        self.teamName = teamName
        self.purpose = purpose
        self.part = part
        self.images = images
        
    }
}
