//
//  MakingAppTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class MakingAppTeamViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teamList: [TeamProfile] = []
    var teamNameList: [String] = []
    var images: [String] = []
    // 프로필 이미지 URL을 위한 변수
    var imageURL: URL  = NSURL() as URL
    var imageData: [[Data]] = [[]]
    var lastDatas: [String] = []
    
    var memberListArr: [[String]] = [[]]
    let db = Database.database().reference()
    var didFetched: Bool = false {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
    
    // 서버에서 팀 받아오기
    func fetchData() {
        self.memberListArr.removeAll()
        
        let favorTeamList = db.child("Team")
        let query = favorTeamList.queryOrdered(byChild: "serviceType").queryEqual(toValue: "앱 서비스")
        
        query.observeSingleEvent(of: .value) { snapshot in
            
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
                    //self.fetchImages(teamIndex: i)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    // cloud storage에서 사진 불러오기
    func fetchImages(teamIndex: Int) {
        
        // 초기화를 위해 생성한 imageData index 비워주기
        if teamIndex == 0 && imageData[0] != nil {
            imageData.removeAll()
        }
        
        // 미리 방 반들어줌
        self.imageData.append(Array(repeating: Data(),count: memberListArr[teamIndex].count))
     
        // 한 팀의 이미지 받아오기
        for memberIndex in 0..<memberListArr[teamIndex].count {
            let userUID = memberListArr[teamIndex][memberIndex]
            let storage = Storage.storage().reference().child("user_profile_image").child(userUID + ".jpg")
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
//        cell.imageData = self.imageData[indexPath.row]
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
