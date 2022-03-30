//
//  User.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/29.
//

import Foundation

/*서버로 받아올 사용자 리스트*/
class User{
    var name: String
    var content: String
    
    init(name: String, content: String){
        self.name = name
        self.content = content
    }
    
    static var dummyUserLsit = [User(name: "first user", content: "개발자"),User(name: "second user", content: "개발자"),User(name: "first user", content: "ui/ux")]
    
    static var dummymemverList = [User(name: "나", content: "UI/UX 디자이너"),User(name: "dn", content: "UI/UX 디자이너"),User(name: "gg", content: "UI/UX 디자이너"),User(name: "as", content: "UI/UX 디자이너"),User(name: "bb", content: "UI/UX 디자이너")]
}
