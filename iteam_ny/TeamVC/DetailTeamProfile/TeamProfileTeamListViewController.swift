//
//  TeamProfileTeamListViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/19.
//

import UIKit

class TeamProfileTeamListViewController: UIViewController {
    @IBOutlet weak var memberTableview: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var indicatorBar: UIView!
    
    var personList: [Person] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableviewHeight.constant = memberTableview.intrinsicContentSize.height
    }
    
    func setUI() {
        indicatorBar.layer.cornerRadius = indicatorBar.frame.height/2
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        
//        if let presentationController = presentationController as? UISheetPresentationController {
//            presentationController.detents = [
//                .medium()
//                .large()
//            ]
//            // grabber 속성 추가
//            presentationController.prefersGrabberVisible = true
//        }
    }
    func setData() {
        personList.append(Person(nickname: "레인", position: "백엔드 개발•포트폴리오/해커톤/창업", callStm: "요청됨", profileImg: "imgUser4"))
        personList.append(Person(nickname: "스카이", position: "Android 개발•포트폴리오/해커톤/창업", callStm: "요청수락", profileImg: "imgUser5"))
        personList.append(Person(nickname: "에일리", position: "Android 개발•공모전/해커톤/기타", callStm: "이전통화", profileImg: "imgUser10"))
        personList.append(Person(nickname: "레인", position: "백엔드 개발•포트폴리오/해커톤/창업", callStm: "요청됨", profileImg: "imgUser4"))
        personList.append(Person(nickname: "스카이", position: "Android 개발•포트폴리오/해커톤/창업", callStm: "요청수락", profileImg: "imgUser5"))
        personList.append(Person(nickname: "에일리", position: "Android 개발•공모전/해커톤/기타", callStm: "이전통화", profileImg: "imgUser10"))
    }
    

}
extension TeamProfileTeamListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamProfileTeamMemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "teamMemberListCell", for: indexPath) as! TeamProfileTeamMemberTableViewCell
        cell.nicknameLabel.text = personList[indexPath.row].nickname
        cell.partLabel.text = personList[indexPath.row].position
        cell.profileImage.image = UIImage(named: "\(personList[indexPath.row].profileImg)")
        
        
        return cell
    }
    
    
}
