//
//  MakingGameTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class MakingGameTeamViewController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    
    var teamList: [TeamProfile] = []
    var teamNameList: [String] = []
    var images: [String] = []
    // 프로필 이미지 URL을 위한 변수
    var imageURL: URL  = NSURL() as URL
    var imageData: [[Data]] = [[]]
    
    
    var memberListArr: [[String]] = [[]]
    let db = Database.database().reference()
    var didFetched: Bool = false {
        didSet {
            self.collView.reloadData()
        }
    }
    var lastDatas: [String] = []
    
    // 더보기 버튼
    @IBAction func moreTeamBtn(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.viewControllers.first as? AllTeamViewController {
            allTeamVC.teamKind = .game
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
        let query = favorTeamList.queryOrdered(byChild: "serviceType").queryEqual(toValue: "게임")
        
        query.observeSingleEvent(of: .value) { snapshot in
            
            guard let value = snapshot.value as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: Array(value.values), options: [])
                let teamData = try JSONDecoder().decode([TeamProfile].self, from: jsonData)
                self.teamList = teamData
                self.teamNameList = Array(value.keys)
                self.collView.reloadData()
                
                
                // 한 팀의 멤버들 UID배열
                for i in 0..<self.teamList.count {
                    self.memberListArr.append([])
                    self.memberListArr[i].append(contentsOf: self.teamList[i].memberList.components(separatedBy: ", "))
                }
                
            } catch let error {
                print(error.localizedDescription)
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
            self.collView.reloadData()
        }
    }
}
extension MakingGameTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "makingGameTeamCell", for: indexPath) as! MakingGameTeamCollectionViewCell
        
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
            allTeamVC.favorTeamList = lastDatas
            present(allTeamVC, animated: true, completion: nil)
        }
    }
}
extension MakingGameTeamViewController: UICollectionViewDelegateFlowLayout {
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
