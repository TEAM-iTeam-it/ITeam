//
//  CompletedTeamViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/05/04.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class CompletedTeamViewController: UIViewController {
    
    // MARK: - Properties
    var teamList: [CTeam] = []
    var images: [String] = []
    let db = Database.database().reference()
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var collView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        
        let firstTeamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
        let firstTeam = CTeam(teamName: "이성책임", subContent: "공모전•2022년 3월 30일 시작",images: firstTeamImages)
        let secondTeam = CTeam(teamName: "Ctrl+P", subContent: "공모전•2022년 3월 30일 시작",images: firstTeamImages)
        
        
        teamList.append(firstTeam)
        teamList.append(secondTeam)
        
        super.viewWillAppear(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let fancyImage = UIImage(systemName:"arrow.left")

        var fancyAppearance = UINavigationBarAppearance()
        fancyAppearance.backgroundColor = UIColor.white
        fancyAppearance.setBackIndicatorImage(fancyImage, transitionMaskImage: fancyImage)

        navigationController?.navigationBar.scrollEdgeAppearance = fancyAppearance
    }
    
    // MARK: - @IBAction Properties
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        let emptyCurrentTeam: [String:String] = ["currentTeam":""]
        let emptyLikeTeam: [String:String] = ["teamName":""]
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("friendsList").removeValue()
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("friendRequest").removeValue()
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("likeTeam").setValue(emptyLikeTeam)
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").removeValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let currentDateString = formatter.string(from: Date())
        
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestStmt").setValue("기본")
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestTime").setValue(currentDateString)
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestUID").setValue("기본")
        
        let emptyUserTeam: [String:String] = ["userTeam":""]
        
        db.child("user").child(Auth.auth().currentUser!.uid).updateChildValues(emptyUserTeam)
   
        
        // call에서 본인 기록 있으면 찾아서 삭제
        var callIndex: String = ""
        db.child("Call").observeSingleEvent(of: .value) { [self] (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                callIndex = "\(snapshots.count)"
                for i in 9...(Int(callIndex) ?? 9) {
                    db.child("Call").child(String(i)).removeValue()
                }
                
            }
        }
        
        // 리더일 때 팀 삭제
        db.child("user").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                if snap.key == "currentTeam" {
                    let teamname: String = snap.value as? String ?? ""
                    if teamname != nil && teamname != "" {
                        self.db.child("Team").child(teamname).observeSingleEvent(of: .value) { snapshot in
                            
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                let value = snap.value as? String
                                // 내가 리더일 때 팀 삭제
                                if snap.key == "leader" {
                                    if value == Auth.auth().currentUser!.uid {
                                        print("리더")
                                        self.db.child("Team").child(teamname).removeValue()
                                        break
                                    }
                                }
                            }
                        }
                    }
        
                }
            }
        }
        db.child("user").child(Auth.auth().currentUser!.uid).updateChildValues(emptyCurrentTeam)
        let sheet = UIAlertController(title: "데이터가 삭제되었습니다", message: "😊👍", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in print("확인") }))
        present(sheet, animated: true)
    }
    
}

class CTeam {
    var teamName: String
    var subContent: String
    var images: [String]
    
    //var profileImg: UIImage
    
    init(teamName: String, subContent: String,images: [String]) {
        self.teamName = teamName
        self.subContent = subContent
        self.images = images
    }
    
    
}

extension CompletedTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "completedTeamCell", for: indexPath) as! CompletedTeamCell
        
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
        
        cell.teamName.text = teamList[indexPath.row].teamName
        cell.subContent.text = teamList[indexPath.row].subContent
        cell.images = teamList[indexPath.row].images
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
//        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.storyboard?.instantiateViewController(withIdentifier: "cellSelectedTeamProfileVC") {
//            // allTeamVC.teamKind = .favor
//            allTeamVC.modalPresentationStyle = .fullScreen
//
//            present(allTeamVC, animated: true, completion: nil)
//        }
//    }
}
extension CompletedTeamViewController: UICollectionViewDelegateFlowLayout {

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 354
        let height = 236
        print("collectionView width=\(collectionView.frame.width)")
        print("cell하나당 width=\(width)")
        print("root view width = \(self.view.frame.width)")

        let size = CGSize(width: width, height: height)
        return size
    }
}

