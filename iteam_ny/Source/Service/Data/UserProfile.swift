//
//  UserProfile.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/03/08.
//

import Foundation

struct user: Codable{
    let uid : Uid
}
struct Uid: Codable {
    let currentTeam: String?
    let evaluation: Evaluation
    let rank : Int
    
    let email : String
    let password: String
    let likeTeam: String = ""
    
    let userProfile: UserProfile
    let userProfileDetail: UserProfileDetail
    
    let favorTeamList: String?
    let userTeam: String?
    
    let isSelected:Bool?
    
}
struct Evaluation: Codable {
    let personCount: Int
    let score: Double
}

struct UserProfile: Codable{
    let nickname:String
    let part: String
    let partDetail: String
    let schoolName: String
    let portfolio : Portfolio?
}

struct UserProfileDetail : Codable{
    let activeZone : String
    let character : String
    let purpose : String
    let wantGrade : String
}

struct Portfolio: Codable {
    let calltime: String
    let contactLink : String
    let ex0 : EX0?
    let interest : String
    let portfolioLink : String?
    let toolNLanguage : String
}
struct EX0: Codable {
    let date : String
    let exDetail : String
    
}

