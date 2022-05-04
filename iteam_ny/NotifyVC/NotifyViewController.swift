//
//  NotifyViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/04.
//

import UIKit

class NotifyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var notiContent: [Noti] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        notiContent.append(Noti(content: "이성책임 팀과의 통화가 곧 시작됩니다.", date: "04/20 14:30", profileImg: "imgUser8"))
        notiContent.append(Noti(content: "레인 님과의 통화가 곧 시작됩니다.", date: "04/17 15:04", profileImg: "imgUser5"))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotifyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "notifyTableViewCell", for: indexPath) as! NotifyTableViewCell
    
        
        cell.ContentLabel.text = notiContent[indexPath.row].content
        cell.dateLabel.text = notiContent[indexPath.row].date
        cell.profileImg.image = UIImage(named: "\(notiContent[indexPath.row].profileImg)")
//        cell.profileImg.image = UIImage(systemName: "person.crop.circle.fill")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

class Noti {
    var content: String
    var date: String
    var profileImg: String
    
    //var profileImg: UIImage
    
    init(content: String, date: String, profileImg: String ) {
        self.content = content
        self.date = date
        self.profileImg = profileImg
        //self.profileImg = profileImg
    }
    
    
}
