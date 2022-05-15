//
//  MakingAppTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MakingAppTeamViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teamList: [TeamProfile] = []
    var teamNameList: [String] = []
    var lastDatas: [String] = []
    
    var memberListArr: [[String]] = [[]]
    let db = Database.database().reference()
 
    var didTeamListFetched: Bool = false {
        willSet(newValue) {
            if newValue {
                fetchMyProfile()
            }
        }
    }
    var didMyProfileFetched: Int = 0 {
        willSet(newValue) {
            print("newValue \(newValue)")
            if newValue >= 2 {
                teamSorting()
            }
        }
    }
    
    var userProfileDetail: UserProfileDetail = UserProfileDetail(activeZone: "", character: "", purpose: "", wantGrade: "")
    var userProfile: UserProfile = UserProfile(nickname: "", part: "", partDetail: "", schoolName: "", portfolio: Portfolio(calltime: "", contactLink: "", ex0: EX0(date: "", exDetail: ""), interest: "", portfolioLink: "", toolNLanguage: ""))
    
    
    // 더보기 버튼
    @IBAction func moreTeamBtn(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.viewControllers.first as? AllTeamViewController {
            allTeamVC.teamKind = .app
            allTeamVC.teamNameList = self.teamNameList
            allTeamVC.favorTeamList = lastDatas
            allTeamNavigation.modalPresentationStyle = .fullScreen
            
            present(allTeamNavigation, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 데이터 받아오기
        fetchData()
        
        // 바뀐 데이터 불러오기
        fetchChangedData()
        
        // 관심팀 받아오기
        doesContainFavorTeam()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    // MARK: - Functions
    // 팀 소팅
    func teamSorting() {
        var purposeRank: [Int : Int] = [:]
        var activeZone = [Bool](repeating: false, count: teamList.count)
        var sortedActiveZone = [Bool](repeating: false, count: teamList.count)
        var part = [Bool](repeating: false, count: teamList.count)
        var sortedPart = [Bool](repeating: false, count: teamList.count)
        let userPurpose = userProfileDetail.purpose.components(separatedBy: ", ")
        var newTeamList: [TeamProfile] = []
        var newTeamNames: [String] = []
        var newUserUID: [[String]] = []
        
        
        // 조건 세팅
        for i in 0..<teamList.count {
            // 내 목적 순위에 따라 점수 세팅
            if teamList[i].purpose == userPurpose[0] {
                purposeRank[i] = 4
            }
            else if teamList[i].purpose == userPurpose[1] {
                purposeRank[i] = 3
            }
            else if teamList[i].purpose == userPurpose[2] {
                purposeRank[i] = 2
            }
            else {
                purposeRank[i] = 1
            }
            // 활동 지역 중복 여부 세팅
            let userActiveZone: [String] = userProfileDetail.activeZone
                .components(separatedBy: ", ")
            
            for index in 0..<userActiveZone.count {
                if teamList[i].activeZone.contains(userActiveZone[index]) {
                    activeZone[i] = true
                }
            }
            
            // 구하는 포지션 중복 여부 세팅
            if teamList[i].detailPart.contains(userProfile.partDetail) {
                part[i] = true
            }
            
        }
        
        // sorting
        
        // 1. 목적 소팅
        let sortedByPurpose = purposeRank.sorted { $0.1 > $1.1 }
        
        for dic in sortedByPurpose {
            // 목적에 따라 소팅된 팀 리스트
            newTeamList.append(teamList[dic.key])
            // 팀리스트와 활동 지역을 맞춰줌
            sortedActiveZone.append(activeZone[dic.key])
            sortedPart.append(part[dic.key])
            newTeamNames.append(teamNameList[dic.key])
            newUserUID.append(memberListArr[dic.key])
        }
        
        // 2. 활동지역, 포지션 일치 소팅
        var allTrue: [TeamProfile] = []
        var oneTypeTrue: [TeamProfile] = []
        var allFalse: [TeamProfile] = []
        
        
        for j in 0..<newTeamList.count {
            
            if sortedActiveZone[j] && sortedPart[j] {
                allTrue.append(newTeamList[j])
            }
            else if sortedActiveZone[j] || sortedPart[j]{
                oneTypeTrue.append(newTeamList[j])
            }
            else {
                allFalse.append(newTeamList[j])
            }
        }
        var resultTeamList: [TeamProfile] = []
        
        resultTeamList += allTrue
        resultTeamList += oneTypeTrue
        resultTeamList += allFalse
        
        print("teamNames[0] \(teamNameList[0])")
        print("newTeamNames[0] \(newTeamNames[0])")
        
        teamList = resultTeamList
        teamNameList = newTeamNames
        memberListArr = newUserUID
        
        
        collectionView.reloadData()
    }
    // 본인 정보 가져오기
    func fetchMyProfile() {
        db.child("user").child(Auth.auth().currentUser!.uid).child("userProfileDetail")
            .observeSingleEvent(of: .value) { [self] snapshot in
                guard let snapData = snapshot.value as? [String : Any] else { return }
                let data = try! JSONSerialization.data(withJSONObject: snapData, options: .prettyPrinted )
                print("data \(data)")
                do {
                    let decoder = JSONDecoder()
                    let profile = try decoder.decode(UserProfileDetail.self, from: data)
                    userProfileDetail = profile
                    print("abcabc")
                    didMyProfileFetched += 1
                } catch let error {
                    print("\(error.localizedDescription)")
                }
            }
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("userProfile").observeSingleEvent(of: .value) { [self] snapshot in
                guard let snapData = snapshot.value as? [String : Any] else { return }
                let data = try! JSONSerialization.data(withJSONObject: snapData, options: .prettyPrinted)
                
                do {
                    let decoder = JSONDecoder()
                    let profile = try decoder.decode(UserProfile.self, from: data)
                    userProfile = profile
                    print("cbacba")
                    didMyProfileFetched += 1
                } catch let error {
                    print("\(error.localizedDescription)")
                }
            }
    }
    
    
    
    // 서버에서 팀 받아오기
    func fetchData() {
        removeData()
        
        let favorTeamList = db.child("Team")
        let query = favorTeamList.queryOrdered(byChild: "serviceType").queryEqual(toValue: "앱 서비스")
        
        query.observeSingleEvent(of: .value) { [self] snapshot in
            
            guard let value = snapshot.value as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: Array(value.values), options: [])
                let teamData = try JSONDecoder().decode([TeamProfile].self, from: jsonData)
                self.teamList = teamData
                self.teamNameList = Array(value.keys)
                self.collectionView.reloadData()
                
                
                // 한 팀의 멤버들 UID배열
                for i in 0..<self.teamList.count {
                    self.memberListArr.append([])
                    self.memberListArr[i].append(contentsOf: self.teamList[i].memberList.components(separatedBy: ", "))
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            didTeamListFetched = true
        }
    }
    // data 초기화
    func removeData() {
        teamList.removeAll()
        teamNameList.removeAll()
        lastDatas.removeAll()
        
        memberListArr.removeAll()
        
        didTeamListFetched = false
        didMyProfileFetched = 0
        userProfileDetail = UserProfileDetail(activeZone: "", character: "", purpose: "", wantGrade: "")
        userProfile = UserProfile(nickname: "", part: "", partDetail: "", schoolName: "", portfolio: Portfolio(calltime: "", contactLink: "", ex0: EX0(date: "", exDetail: ""), interest: "", portfolioLink: "", toolNLanguage: ""))
        collectionView.reloadData()
        
    }
 
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
        db.child("Team").observe(.childChanged, with:{ (snapshot) -> Void in
            DispatchQueue.main.async {
                self.fetchData()
            }
        })
        db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").observe(.childChanged, with:{ (snapshot) -> Void in
            DispatchQueue.main.async {
                self.doesContainFavorTeam()
            }
        })
    }

    // 관심 팀에 속해있는지 확인
    func doesContainFavorTeam() {
        let user = Auth.auth().currentUser!
        let ref = Database.database().reference()
        var doesContainBool: Bool = false
        
        ref.child("user").child(user.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) {snapshot in
            let lastData: String! = snapshot.value as? String
            if lastData  != nil {
                self.lastDatas = lastData.components(separatedBy: ", ")
            }
            self.collectionView.reloadData()
        }
    }
    
}
extension MakingAppTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "makingAppTeamCell", for: indexPath) as! MakingAppTeamCollectionViewCell
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.layer.masksToBounds = false
        
        cell.teamName.text = teamNameList[indexPath.row] + " 팀"
        cell.purpose.text = teamList[indexPath.row].purpose
        cell.part.text = teamList[indexPath.row].part
        cell.userUID = memberListArr[indexPath.row]

        if lastDatas.contains(cell.teamName.text!) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = UIColor(named: "purple_184")
            cell.likeBool = true
        }
        else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = UIColor(named: "gray_196")
            cell.likeBool = false
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.storyboard?.instantiateViewController(withIdentifier: "cellSelectedTeamProfileVC") as? TeamProfileViewController {
            // allTeamVC.teamKind = .favor
            allTeamVC.modalPresentationStyle = .fullScreen
            allTeamVC.teamName = teamNameList[indexPath.row] + " 팀"
            allTeamVC.teamProfile = teamList[indexPath.row]
       //     allTeamVC.teamImageData = imageData[indexPath.row]
            allTeamVC.favorTeamList = lastDatas
            present(allTeamVC, animated: true, completion: nil)
        }
    }
}
extension MakingAppTeamViewController: UICollectionViewDelegateFlowLayout {
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 186
        let height = 204

        let size = CGSize(width: width, height: height)
        return size
    }
    
    
}
