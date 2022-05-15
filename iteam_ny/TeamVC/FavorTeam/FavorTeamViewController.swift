//
//  FavorTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseStorage
import Kingfisher
import Tabman

class FavorTeamViewController: UIViewController {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addalertLabel: UILabel!
    
    var teamList: [TeamProfile] = []
    var teamNameList: [String] = []
    var memberListArr: [[String]] = [[]]
    let db = Database.database().reference()
    var doesFavorTeamExisted: Bool = false
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
    var teamNames: [String] = []
    var teamListNew: [TeamProfile] = []
    var teamNamesNew: [String] = []
    var userUID: [[String]] = []
    var userProfileDetail: UserProfileDetail = UserProfileDetail(activeZone: "", character: "", purpose: "", wantGrade: "")
    var userProfile: UserProfile = UserProfile(nickname: "", part: "", partDetail: "", schoolName: "", portfolio: Portfolio(calltime: "", contactLink: "", ex0: EX0(date: "", exDetail: ""), interest: "", portfolioLink: "", toolNLanguage: ""))
    
    
    // 팀 더보기
    @IBAction func moreTeamBtn(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.viewControllers.first as? AllTeamViewController {
            allTeamVC.teamKind = .favor
            allTeamVC.teamNameList = self.teamNameList
            allTeamVC.favorTeamList = self.teamNames
            allTeamNavigation.modalPresentationStyle = .fullScreen
            
            present(allTeamNavigation, animated: true, completion: nil)
        }
    }
    
    func teamSorting() {
        var poo = ["C": "Canada", "B": "Bulgaria", "A": "Australia"]
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

        print("teamList.count \(teamList.count)")
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
            print("purposeRank.values \(purposeRank.values)")
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
        
        print("purposeRank.key \(purposeRank[0])")
        let sortedByPurpose = purposeRank.sorted { $0.1 > $1.1 }
        
        for dic in sortedByPurpose {
            print("dic.key = \(dic.key)")
            print("dic.value = \(dic.value)")
            // 목적에 따라 소팅된 팀 리스트
            newTeamList.append(teamList[dic.key])
            // 팀리스트와 활동 지역을 맞춰줌
            sortedActiveZone.append(activeZone[dic.key])
            sortedPart.append(part[dic.key])
            newTeamNames.append(teamNames[dic.key])
            newUserUID.append(userUID[dic.key])
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
        
        print("teamNames[0] \(teamNames[0])")
        print("newTeamNames[0] \(newTeamNames[0])")
        teamList = resultTeamList
        teamNames = newTeamNames
        userUID = newUserUID
        
        
        collView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 데이터 받아오기
        fetchData()
        
        //fetchMyProfile()
        
        addalertLabel.isHidden = true
        
        // 바뀐 데이터 불러오기
        fetchChangedData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    func removeData() {
        self.memberListArr.removeAll()
        teamList.removeAll()
        teamNameList.removeAll()
        memberListArr.removeAll()
        doesFavorTeamExisted = false
        didMyProfileFetched = 0
        teamNames.removeAll()
        teamListNew.removeAll()
        teamNamesNew.removeAll()
        userUID.removeAll()
        
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
        
        let favorTeamList = db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").child("teamName")
        
        favorTeamList.observeSingleEvent(of: .value) { [self] favorSnapshot in
            
            let value = favorSnapshot.value as? String ?? "none"
            
            teamNames.removeAll()
            teamNames = value.components(separatedBy: ", ").map({$0.replacingOccurrences(of: " 팀", with: "")})
            
            
            if value == "none" || value == "" {
                collView.isHidden = true
                addalertLabel.isHidden = false
                addButton.isHidden = true
                
            }
            else {
                collView.isHidden = false
                addalertLabel.isHidden = true
                addButton.isHidden = false
                self.fetchFavorTeam()
            }
            
        }
    }
    func fetchFavorTeam() {
        teamNameList.removeAll()
        db.child("Team").observeSingleEvent(of: .value, with: { [self] (snapshot) in
            let values = snapshot.value
            guard let dic = values as? [String: [String:Any]] else {
                collView.isHidden = true
                addalertLabel.isHidden = false
                addButton.isHidden = true
                return
            }
            
            self.teamListNew.removeAll()
            self.teamNamesNew.removeAll()
            var count = 0
            
            
            for index in dic{
                count += 1
                
                for i in 0..<self.teamNames.count {
                    if index.key == self.teamNames[i] {
                        
                        let teamProfile = TeamProfile(
                            purpose: index.value["purpose"] as! String,
                            serviceType: index.value["serviceType"] as! String,
                            part: index.value["part"] as! String,
                            detailPart: index.value["detailPart"] as! String,
                            introduce: index.value["introduce"] as? String ?? "",
                            contactLink: index.value["contactLink"] as! String,
                            callTime: index.value["callTime"]  as! String,
                            activeZone: index.value["activeZone"] as! String,
                            memberList: index.value["memberList"] as! String)
                        
                        // part 바꾸면 아래 세개 실행되지 않음. 값이 없음..
                        teamListNew.append(teamProfile)
                        teamNameList.append(self.teamNames[i])
                        teamNamesNew.append("\(self.teamNames[i]) 팀")
                    }
                }
                if count == dic.count {
                    update(teamList: teamListNew, teamNames: teamNamesNew)
                }
            }
            didTeamListFetched = true
        })
        
    }
    // member uid 받아오기 만들기
    func update(teamList: [TeamProfile], teamNames: [String]) {
        // 오류-> 데이터 업데이트되면 이 부분 실행 안됨
        self.teamList = teamList
        self.teamNames = teamNames
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
        // 한 팀의 멤버들 UID배열
        for i in 0..<self.teamList.count {
            self.memberListArr.append([])
            self.memberListArr[i].append(contentsOf: self.teamList[i].memberList.components(separatedBy: ", "))
            self.fetchMemberUID(teamIndex: i)
        }
        
    }
    func fetchMemberUID(teamIndex: Int) {
        
        // 미리 방 반들어줌
        self.userUID.append(Array(repeating: "",count: memberListArr[teamIndex].count))
        // 한 팀의 UID 받기
        for memberIndex in 0..<memberListArr[teamIndex].count {
            userUID[teamIndex][memberIndex] = memberListArr[teamIndex][memberIndex]
        }
        
    }
    
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
        // 이게 문제
        
        db.child("Team").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchData()
            }
        })
        
        db.child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchData()
            }
        })
    }
    
    
    
    
    
    
    
}

extension FavorTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favorTeamCell", for: indexPath) as! FavorTeamCollectionViewCell
        
        // 셀 디자인 및 데이터 세팅
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
        
        cell.teamName.text = teamNames[indexPath.row]
        cell.purpose.text = teamList[indexPath.row].purpose
        cell.part.text = teamList[indexPath.row].part
        

        cell.usersUID = self.userUID[indexPath.row]
        cell.likeBool = true
        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.likeButton.tintColor = UIColor(named: "purple_184")
        
        return cell
    }
    
    // 셀 클릭시 세부 프로필
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.storyboard?.instantiateViewController(withIdentifier: "cellSelectedTeamProfileVC") as? TeamProfileViewController {
            // allTeamVC.teamKind = .favor
            allTeamVC.modalPresentationStyle = .fullScreen
            allTeamVC.teamName = teamNames[indexPath.row]
            allTeamVC.teamProfile = teamList[indexPath.row]
            allTeamVC.favorTeamList = teamNames
            
            present(allTeamVC, animated: true, completion: nil)
        }
    }
}
extension FavorTeamViewController: UICollectionViewDelegateFlowLayout {
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
    }
    
    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 261
        let height = 198
        
        let size = CGSize(width: width, height: height)
        return size
    }
}

