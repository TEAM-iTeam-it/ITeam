//
//  AllTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AllTeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var teamList: [Team] = []
    enum TeamKind {
        case favor
        case app
        case web
        case game
    }
    var teamKind: TeamKind = .favor
    var teamNameList: [String] = []
    var teamProfileList: [TeamProfile] = []
    let db = Database.database().reference()
    var imageData: [[Data]] = [[]]
    var favorTeamList: [String] = []
    
    
    // @나연 : 삭제할 더미데이터 -> 추후 서버에서 받아와야함
    let firstTeamImages: [String] = ["imgUser10.png", "imgUser2.png", "imgUser3.png"]
    let secondTeamImages: [String] = ["imgUser6.png", "imgUser7.png", "imgUser2.png"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setUI()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<teamNameList.count {
            print(i)
            fetchTeamInfo(index: i)
        }
        fetchChangedData()
        tableView.reloadData()
    }
    
    
    
    func setUI () {
        
        // 각 teamkind의 경우에 따라 데이터 받아와서 teamList에 넣어줌
        switch teamKind {
        case .favor:
            // 관심있는 팀 받아오는 코드 작성
            titleLabel.text = "내가 관심있는 팀들"
        case .app:
            // 앱을 만들고 있는 팀 받아오는 코드 작성
            titleLabel.text = "지금 앱을 만들고 있는,"
        case .web:
            // 웹을 만들고 있는 팀 받아오는 코드 작성
            titleLabel.text = "지금 웹을 만들고 있는,"
        case .game:
            // 게임 만들고 있는 팀 받아오는 코드 작성
            titleLabel.text = "지금 게임을 만들고 있는,"
        }
        
        navigationController?.navigationBar.backgroundColor = .white
      //'  navigationController?.navigationBar.shadowImage = UIImage()
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: true, completion: nil)
    }
    
    // 관심 팀에 속해있는지 확인
    func doesContainFavorTeam() {
        let user = Auth.auth().currentUser!
        let ref = Database.database().reference()
        var doesContainBool: Bool = false
        
        ref.child("user").child(user.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) {snapshot in
            let lastData: String! = snapshot.value as? String
            self.favorTeamList = lastData.components(separatedBy: ", ")
            
            self.tableView.reloadData()
        }
    }
    
    
    func fetchTeamInfo(index: Int) {
        db.child("Team").child(teamNameList[index]).observeSingleEvent(of: .value) { [self] snapshot in
            let value = snapshot.value as! [String : String]
 
            let purpose = value["purpose"]!
            let serviceType = value["serviceType"]!
            let part = value["part"]!
            let detailPart = value["detailPart"]!
            let introduce = value["introduce"]!
            let contactLink = value["contactLink"]!
            let callTime = value["callTime"]!
            let activeZone = value["activeZone"]!
            let memberList = value["memberList"]!
            
            let team = Team(teamName: teamNameList[index], purpose: purpose, part: part, images: firstTeamImages)
            teamList.append(team)
            
            let teamprofile = TeamProfile(purpose: purpose, serviceType: serviceType, part: part, detailPart: detailPart, introduce: introduce, contactLink: contactLink, callTime: callTime, activeZone: activeZone, memberList: memberList)
            teamProfileList.append(teamprofile)
            fetchImages(teamIndex: index)
            
            tableView.reloadData()
        }
    }
    // cloud storage에서 사진 불러오기
    func fetchImages(teamIndex: Int) {
        
        let memberUIDList = teamProfileList[teamIndex].memberList.components(separatedBy: ", ")
        let memberCount = memberUIDList.count
        
        // 미리 방 반들어줌
    
        if imageData.contains([]) {
            imageData.remove(at: 0)
        }
        self.imageData.append(Array(repeating: Data(),count: memberCount))
        
        // 한 팀의 이미지 받아오기
        for memberIndex in 0..<memberCount {
            let storage = Storage.storage().reference().child("user_profile_image").child(memberUIDList[memberIndex] + ".jpg")
            storage.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // 다운로드 성공
                    print("사진 다운로드 성공")
                    var imageURL: URL  = NSURL() as URL
                    imageURL = url!
                    let data = try? Data(contentsOf: imageURL)
                    
                    // 비동기적으로 데이터 세팅 및 collectionview 리로드
                    DispatchQueue.main.async {
                        self.imageData[teamIndex][memberIndex] = data!
                    }
                }
            }
        }
    }
    
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
        db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.doesContainFavorTeam()
            }
        })
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
        
        cell.circleTitleView.layer.cornerRadius = cell.circleTitleView.frame.height/2
        cell.circleTitleView.layer.masksToBounds = true
        cell.teamProfileLabel.text = String(teamFirstName)
        cell.teamName.text = "\(teamList[indexPath.row].teamName) 팀"
        cell.part.text = "\(teamList[indexPath.row].purpose)•\(teamList[indexPath.row].part) 구인 중"
     
        if favorTeamList.contains(cell.teamName.text!) {
            cell.favorButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.favorButton.tintColor = UIColor(named: "purple_184")
            cell.likeBool = true
            print(cell.likeBool)
            print(indexPath.row)
        }
        else {
            cell.favorButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.favorButton.tintColor = UIColor(named: "gray_196")
            cell.likeBool = false
            print(cell.likeBool)
            print(indexPath.row)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.storyboard?.instantiateViewController(withIdentifier: "cellSelectedTeamProfileVC") as? TeamProfileViewController {
            // allTeamVC.teamKind = .favor
            allTeamVC.modalPresentationStyle = .fullScreen
            allTeamVC.teamName = teamList[indexPath.row].teamName + " 팀"
            allTeamVC.teamProfile = teamProfileList[indexPath.row]
            allTeamVC.teamImageData = imageData[indexPath.row]
            allTeamVC.favorTeamList = favorTeamList
            present(allTeamVC, animated: true, completion: nil)
        }
    }
    
}

