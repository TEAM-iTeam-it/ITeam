//
//  TeamProfileTeamListViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/19.
//

import UIKit
import FirebaseDatabase
import Firebase

class TeamProfileTeamListViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var memberTableview: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var titleLabelConstraint: NSLayoutConstraint!
    
    var personList: [Person] = []
    var personProfileList: [UserProfileSimple] = []
    var didFetched: Int = 0 {
        didSet {
            memberTableview.reloadData()
        }
    }
    var teamImageData: [Data] = []
    var teamMemberUID: String = ""
    var memberUID: [String] = []
    let db = Database.database().reference()
    var memberCountSeven: Bool = false
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setData()
        setUI()
        fetchMember()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableviewHeight.constant = memberTableview.intrinsicContentSize.height
    }
    
    // MARK: - Functions
    func setUI() {
        indicatorBar.layer.cornerRadius = indicatorBar.frame.height/2
        view.layer.cornerRadius = 30
        
        memberUID = teamMemberUID.components(separatedBy: ", ")
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            presentationController.prefersGrabberVisible = true
            
        }
        
        if memberCountSeven {
            titleLabelConstraint.constant = 30
            
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .medium(),
                    .large()
                ]
                presentationController.prefersGrabberVisible = true
                
            }
        }
        else {
            titleLabelConstraint.constant = -13
        }
        
    }


    func fetchMember() {
        
        print(memberUID.count)
        // self.memberListArr.removeAll()
        
        let memberDB = db.child("user")
        
        memberDB.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                for memberIndex in 0..<memberUID.count {
                    
                    var nickname = ""
                    var part = ""
                    var partDetail = ""
                    var purpose = ""
                    
                    if snap.key == memberUID[memberIndex] {
                        for (key, content) in value! {
                            
                            if key as! String == "userProfile" {
                                let getContent = content as! NSDictionary
                                nickname = getContent["nickname"] as! String
                                part = getContent["part"] as! String
                                partDetail = getContent["partDetail"] as! String
                                if part == "개발자" {
                                    partDetail += " 개발자"
                                }
                                
                            }
                            if key as! String == "userProfileDetail" {
                                let getContent = content as! NSDictionary
                                purpose = getContent["purpose"] as! String
                                purpose = purpose.replacingOccurrences(of: ", ", with: "/")
                            }
                            
                        }
                        
                        let personProfile = UserProfileSimple(
                            nickname: nickname,
                            part: part,
                            partDetail: partDetail,
                            purpose: purpose)
                        
                        DispatchQueue.main.async {
                            personProfileList.append(personProfile)
                            print("personProfileList.count \(personProfileList.count)")
                            didFetched += 1
                        }
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
}
extension TeamProfileTeamListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !memberUID.isEmpty && memberUID.count <= 3 {
            return memberUID.count
        }
        else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamProfileTeamMemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "teamMemberListCell", for: indexPath) as! TeamProfileTeamMemberTableViewCell
        
        if !personProfileList.isEmpty {
            
            cell.nicknameLabel.text = personProfileList[indexPath.row].nickname
            cell.partLabel.text = "\(personProfileList[indexPath.row].partDetail)•\(personProfileList[indexPath.row].purpose)"
            cell.profileImage.layer.cornerRadius = 25
            
            // kingfisher 사용하기 위한 url
            let uid: String = memberUID[indexPath.row]
            
            let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
            
            // Fetch the download URL
            starsRef.downloadURL { [self] url, error in
                if let error = error {
                } else {
                    cell.profileImage.kf.setImage(with: url)
                }
            }
        }
        
        return cell
    }
    // 이미지 리사이징
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
