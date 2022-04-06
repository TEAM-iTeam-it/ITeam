//
//  TeamProfileViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/31.
//

import UIKit

class TeamProfileViewController: UIViewController {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamPurposeLabel: UILabel!
    @IBOutlet weak var teamPartLabel: UILabel!
    @IBOutlet weak var teamIntroduceLabel: UILabel!
    @IBOutlet weak var callRequestBtn: UIButton!
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var teamImageColl: UICollectionView!
    
    
    // @나연 : 테이블뷰에서 셀 선택시 팀 이름을 넘겨주기 때문에 서버에서 팀 이름을 검색해서 팀 데이터를 받아오면 될 것 같습니다
    var teamName: String = ""
    var team: Team = Team(teamName: "", purpose: "", part: "", images: [])
    
    // @나연 : 삭제할 더미데이터 -> 추후 서버에서 받아와야함
    let teamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.shadowImage = UIImage()
        teamImageColl.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft

        callRequestBtn.layer.cornerRadius = 8
      
        
        
        callRequestBtn.layer.masksToBounds = true
        
        teamView.backgroundColor = .white
        teamView.layer.cornerRadius = 20
        teamView.layer.borderWidth = 0
        teamView.layer.borderColor = UIColor.black.cgColor
        teamView.layer.shadowColor = UIColor.black.cgColor
        teamView.layer.shadowOffset = CGSize(width: 0, height: 0)
        teamView.layer.shadowOpacity = 0.2
        teamView.layer.shadowRadius = 10
        teamView.layer.masksToBounds = true
        teamView.layer.masksToBounds = false
        
        
        // @나연 : 여기서 서버에서 받아온 데이터를 화면에 뿌려줌
        teamNameLabel.text = teamName
//        teamPurposeLabel.text = team.purpose
//        teamPartLabel.text = team.part
        
        super.viewWillAppear(false)
    }
    
    @IBOutlet weak var profileImagesColl: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension TeamProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 커스텀 셀 따로 만들지 않고 어차피 이미지만 들어간 셀이라 그냥 사용
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailTeamProfileCell", for: indexPath) as! TeamProfileImageCollectionViewCell
        
        // 셀 디자인 및 데이터 세팅
        cell.userImage.image = UIImage(named: teamImages[indexPath.row])
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor(ciColor: .white).cgColor
    
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    
}
extension TeamProfileViewController: UICollectionViewDelegateFlowLayout {

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -30.0
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 75
        let height = 75
        

        let size = CGSize(width: width, height: height)
        return size
    }
    
    // 중앙 정렬
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemWidth = 75
        let spacingWidth = -20
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let cellSpacingWidth = numberOfItems * spacingWidth
        let totalCellWidth = numberOfItems * itemWidth + cellSpacingWidth
        let inset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
        return UIEdgeInsets(top: 5, left: inset, bottom: 5, right: inset)
    }
}
class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(named: "purple_184")?.cgColor, UIColor(named: "green_144")?.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 8
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

