//
//  UserProfile.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/03/08.
//

import Foundation

//struct Uid: Codable {
//    let email : String
//    let password: String
//    let userProfile: UserProfile
//    let userProfileDetail: UserProfileDetail
//    let isSelected:Bool?
//}
//
//struct UserProfile: Codable{
//    let nickname:String
//    let part: String
//    let partDetail: String
//    let schoolName: String
//}
//
//struct UserProfileDetail : Codable{
//    let activeZone : ActiveZone
//    let character : Character
//    let purpose : Purpose
//let names : Array<String>
//let tags: [String]

//}
//
//struct ActiveZone: Codable{
//    let 0 : String
//    let 1 : String
//    let 2: String
//}
//
//struct Character : Codable{
//    let 0 : String
//    let 2: String
//    let 1: String
//}
//
//struct Purpose : Codable{
//    let 0 : String
//    let 2: String
//    let 1: String
//}

struct UserProfile: Codable{
    let id : Int
    let rank : Int
    let userprofileDetail: UserProfileDetail
    let isSelected: Bool? // 사용자 클릭시 생성
}

struct UserProfileDetail: Codable{
    let name : String
//    let userImageURL : String
    let part : String
    let purpose : String
    let character: String
    let language: String
    let interest: String
    let date : String
    let exDetail : String
    let calltime : String
    let portfolio : String
    let contactLink : String
}
