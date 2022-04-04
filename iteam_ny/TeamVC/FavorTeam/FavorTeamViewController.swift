//
//  FavorTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit

class FavorTeamViewController: UIViewController {
    var teamList: [Team] = []
    var images: [String] = []
    @IBOutlet weak var collView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // @나연 : 삭제할 더미데이터 -> 추후 서버에서 받아와야함
        let firstTeamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
        let firstTeam = Team(teamName: "이성책임", purpose: "공모전", part: "디자이너, 개발자 구인 중", images: firstTeamImages)
        let secondTeam = Team(teamName: "Ctrl+P", purpose: "포트폴리오", part: "모든 파트 구인 중", images: firstTeamImages)
        let thirdTeam = Team(teamName: "가온누리", purpose: "함께 논의해 봐요", part: "개발자 구인 중", images: firstTeamImages)
        
        
        teamList.append(firstTeam)
        teamList.append(secondTeam)
        teamList.append(thirdTeam)
        
        super.viewWillAppear(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func moreTeamBtn(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
        if let allTeamNavigation = storyboard.instantiateInitialViewController() as? UINavigationController, let allTeamVC = allTeamNavigation.viewControllers.first as? AllTeamViewController {
            allTeamVC.teamKind = .favor
            allTeamNavigation.modalPresentationStyle = .fullScreen
           
            present(allTeamNavigation, animated: true, completion: nil)
        }
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
        
        cell.teamName.text = teamList[indexPath.row].teamName
        cell.purpose.text = teamList[indexPath.row].purpose
        cell.part.text = teamList[indexPath.row].part
        cell.images = teamList[indexPath.row].images
        
        return cell
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
        print("collectionView width=\(collectionView.frame.width)")
        print("cell하나당 width=\(width)")
        print("root view width = \(self.view.frame.width)")

        let size = CGSize(width: width, height: height)
        return size
    }
}

