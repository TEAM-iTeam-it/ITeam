//
//  FavorTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import Firebase
import FirebaseStorage
import Tabman
import Kingfisher

class FavorTeamViewController: UIViewController {
    
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var addalertLabel: UILabel!
    var images: [String] = []
    var teamList: [TeamProfile] = []
    var teamNameList: [String] = []
    var memberListArr: [[String]] = [[]]
    var uiImages: [[UIImage]] = [[]]
    // 프로필 이미지 URL을 위한 변수
    var imageURL: URL  = NSURL() as URL
    var imageData: [[Data]] = [[]]
    let db = Database.database().reference()
    var doesFavorTeamExisted: Bool = false
    var didFetched: Bool = false {
        didSet {
            self.collView.reloadData()
        }
    }
    var teamNames: [String] = []
    @IBOutlet weak var addButton: UIButton!
    
    var teamListNew: [TeamProfile] = []
    var teamNamesNew: [String] = []
    var userUID: [[String]] = []
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 데이터 받아오기
        fetchData()
        addalertLabel.isHidden = true
        
        // 바뀐 데이터 불러오기
        fetchChangedData()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    // 서버에서 팀 받아오기
    func fetchData() {
        self.memberListArr.removeAll()
        
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
        let favorTeamList = db.child("Team")
        teamNameList.removeAll()
        
        favorTeamList.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            let values = snapshot.value
            let dic = values as! [String: [String:Any]]
            self.teamListNew.removeAll()
            self.teamNamesNew.removeAll()
            
            for index in dic{
                for i in 0..<self.teamNames.count {
                    if index.key == self.teamNames[i] {
                        
                        let teamProfile = TeamProfile(
                            purpose: index.value["purpose"] as! String,
                            serviceType: index.value["serviceType"] as! String,
                            part: index.value["part"] as! String,
                            detailPart: index.value["detailPart"] as! String,
                            introduce: index.value["introduce"] as! String,
                            contactLink: index.value["contactLink"] as! String,
                            callTime: index.value["callTime"]  as! String,
                            activeZone: index.value["activeZone"] as! String,
                            memberList: index.value["memberList"] as! String)
                        
                        teamListNew.append(teamProfile)
                        teamNameList.append(self.teamNames[i])
                        teamNamesNew.append("\(self.teamNames[i]) 팀")
                    }
                }
            }
            self.teamList = teamListNew
            self.teamNames = teamNamesNew
            self.collView.reloadData()
            
            
            // 한 팀의 멤버들 UID배열
            for i in 0..<self.teamList.count {
                
                self.memberListArr.append([])
                self.memberListArr[i].append(contentsOf: self.teamList[i].memberList.components(separatedBy: ", "))
                // self.fetchImages(teamIndex: i)
            }
            
        })
        

        
    }
    
    // cloud storage에서 사진 불러오기
    func fetchImages(teamIndex: Int) {
        
        // 초기화를 위해 생성한 imageData index 비워주기
        if teamIndex == 0 && imageData[0] != nil {
            imageData.removeAll()
        }
        
        // 미리 방 반들어줌
        self.imageData.append(Array(repeating: Data(),count: memberListArr[teamIndex].count))
        self.userUID.append(Array(repeating: "",count: memberListArr[teamIndex].count))
     
        // 한 팀의 이미지 받아오기
        for memberIndex in 0..<memberListArr[teamIndex].count {
            
            userUID[teamIndex][memberIndex] = memberListArr[teamIndex][memberIndex]
            
            let storage = Storage.storage().reference().child("user_profile_image").child(userUID[teamIndex][memberIndex] + ".jpg")
            
      
            storage.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // 다운로드 성공
                    print("사진 다운로드 성공")
                    self.imageURL = url!
                    let data = try? Data(contentsOf: self.imageURL)
                   
                    // 비동기적으로 데이터 세팅 및 collectionview 리로드
                    DispatchQueue.main.async {
                        self.imageData[teamIndex][memberIndex] = data!
                        self.didFetched = true
                    }
                }
            }
            
        }
        
    }
 
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
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
        
        //cell.imageData = self.imageData[indexPath.row]
      //  cell.usersUID = self.userUID[indexPath.row]
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
         //   allTeamVC.teamImageData = imageData[indexPath.row]
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

