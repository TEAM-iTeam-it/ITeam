//
//  TeamProfile.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/26.
//

import Foundation

struct TeamProfile: Codable {
    let purpose: String
    let serviceType: String
    let part: String
    let detailPart: String
    let introduce: String
    let contactLink: String
    let callTime: String
    let activeZone: String
    let memberList: String
}

struct UserProfileSimple {
    let nickname: String
    let part: String
    let partDetail: String
    let purpose: String
}
