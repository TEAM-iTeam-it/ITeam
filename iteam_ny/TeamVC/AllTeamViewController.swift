//
//  AllTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit

class AllTeamViewController: UIViewController {

    var teamList: [Team] = []
    enum TeamKind {
        case favor
        case app
        case web
        case game
    }
    var teamKind: TeamKind = .favor
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // @나연 : 삭제할 더미데이터 -> 추후 서버에서 받아와야함
        let firstTeamImages: [String] = ["imgUser10.png", "imgUser2.png", "imgUser3.png"]
        let secondTeamImages: [String] = ["imgUser6.png", "imgUser7.png", "imgUser2.png"]
        
        let firstTeam = Team(teamName: "원더", purpose: "해커톤", part: "디자이너 구인 중", images: firstTeamImages)
        let secondTeam = Team(teamName: "Coddi", purpose: "포트폴리오", part: "개발자 구인 중", images: secondTeamImages)
        let thirdTeam = Team(teamName: "이성책임", purpose: "함께 논의해 봐요", part: "개발자 구인 중", images: firstTeamImages)
        
        
        teamList.append(firstTeam)
        teamList.append(secondTeam)
        teamList.append(thirdTeam)
        
        
        // @나연 : 각 teamkind의 경우에 따라 데이터 받아와서 teamList에 넣어주시면 됩니다!
//        switch teamKind {
//        case .favor:
//            // 관심있는 팀 받아오는 코드 작성
//        case .app:
//            // 앱을 만들고 있는 팀 받아오는 코드 작성
//        case .web:
//            // 웹을 만들고 있는 팀 받아오는 코드 작성
//        case .game:
//            // 게임 만들고 있는 팀 받아오는 코드 작성
//        }
        
        super.viewWillAppear(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
extension AllTeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamListCell", for: indexPath) as! AllTeamListTableViewCell
        let teamname: String = teamList[indexPath.row].teamName
        let teamFirstName = teamname[teamname.startIndex]
        
        cell.teamProfileLabel.layer.cornerRadius = cell.teamProfileLabel.frame.height/2
        cell.teamProfileLabel.text = String(teamFirstName)
        cell.teamName.text = teamList[indexPath.row].teamName
        cell.part.text = teamList[indexPath.row].part
        return cell
    }
    
    
}
