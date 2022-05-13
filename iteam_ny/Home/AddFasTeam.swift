//
//  AddFasTeam.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit

class AddFasTeam:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    var friendContent: [friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendContent.append(friend(content: "ios개발, 공모전", name: "에일리", profileImg: "imgUser5"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addfriendCell", for: indexPath) as! AddfriendCell
        
        cell.friendProfile.text = friendContent[indexPath.row].content
        cell.friendName.text = friendContent[indexPath.row].name
        cell.userImg.image = UIImage(named: "\(friendContent[indexPath.row].profileImg)")
        
        return cell
    }
    

}

class friend {
    var content: String
    var name: String
    var profileImg: String

    //var profileImg: UIImage

    init(content: String, name: String, profileImg: String ) {
        self.content = content
        self.name = name
        self.profileImg = profileImg
        //self.profileImg = profileImg
    }


}
