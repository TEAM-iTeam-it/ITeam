//
//  User.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/29.
//

import Foundation

class User{
    var name: String
    var content: String
    
    init(name: String, content: String){
        self.name = name
        self.content = content
    }
    
    static var dummyUserLsit = [User(name: "first user", content: "개발자"),User(name: "second user", content: "개발자")]
}
