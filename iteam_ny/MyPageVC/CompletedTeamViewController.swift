//
//  CompletedTeamViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/04.
//

import UIKit

class CompletedTeamViewController: UIViewController {
    var teamList: [CTeam] = []
    var images: [String] = []
    @IBOutlet weak var collView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // @나연 : 삭제할 더미데이터 -> 추후 서버에서 받아와야함
        let firstTeamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
        let firstTeam = CTeam(teamName: "이성책임", subContent: "공모전•2022년 3월 30일 시작",images: firstTeamImages)
        let secondTeam = CTeam(teamName: "Ctrl+P", subContent: "공모전•2022년 3월 30일 시작",images: firstTeamImages)
        
        
        teamList.append(firstTeam)
        teamList.append(secondTeam)
        
        super.viewWillAppear(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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

