//
//  MyPartViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/05/29.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyPartViewController: UIViewController {
    @IBOutlet weak var partTableview: UITableView!
    @IBOutlet weak var detailPartTableView: UITableView!
    
    @IBOutlet weak var partNavigationBar: UINavigationBar!
    
    var delegate: PartDataDelegate?
    var ref = Database.database().reference().child("user")
    
    let part: [String] = ["기획자", "디자이너", "개발자"]
    var detailPart: [String] = []
    var plannerDetailPart: [String] = ["앱 기획자", "웹 기획자", "게임 기획자", "", ""]
    var designerDetailPart: [String] = ["UI/UX 디자이너", "일러스트레이터", "모델러", "", ""]
    var devDetailPart: [String] = ["Android 개발", "iOS 개발", "웹 개발", "백엔드 개발", "게임 개발"]
    var didClicked: [Bool] = [false, false, false]
    var detailPartDidClicked: [Bool] = []
    var clickedPart: [String] = []
    var clckedDetailPart: String = ""
    var clickedPartArr: String = ""

    
    var num: Int = 0 {
        willSet(newValue) {
            print(newValue)
            if newValue == 1 {
                detailPart = plannerDetailPart
                didClicked[0] = true
                didClicked[1] = false
                didClicked[2] = false
                
                detailPartDidClicked.removeAll()
                for _ in 0..<plannerDetailPart.count {
                    detailPartDidClicked.append(false)
                }
            }
            else if newValue == 2 {
                detailPart = designerDetailPart
                didClicked[0] = false
                didClicked[1] = true
                didClicked[2] = false
                
                detailPartDidClicked.removeAll()
                for _ in 0..<designerDetailPart.count {
                    detailPartDidClicked.append(false)
                }
            }
            else if newValue == 3 {
                detailPart = devDetailPart
                didClicked[0] = false
                didClicked[1] = false
                didClicked[2] = true
                
                detailPartDidClicked.removeAll()
                for _ in 0..<devDetailPart.count {
                    detailPartDidClicked.append(false)
                }
            }
            detailPartTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partTableview.separatorStyle = .none
        detailPartTableView.separatorStyle = .none
        partNavigationBar.shadowImage = UIImage()
        detailPart = plannerDetailPart
        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: Any) {
        var plannerBool: Bool = false
        var designerBool: Bool = false
        var devBool: Bool = false
        for i in 0..<plannerDetailPart.count {
            if clckedDetailPart.contains(plannerDetailPart[i]) {
                plannerBool = true
            }
        }
        for i in 0..<designerDetailPart.count {
            if clckedDetailPart.contains(designerDetailPart[i]) {
                designerBool = true
            }
        }
        for i in 0..<devDetailPart.count {
            if clckedDetailPart.contains(devDetailPart[i]) {
                devBool = true
            }
        }
        clickedPartArr.removeAll()
        if plannerBool {
            clickedPartArr = "기획자"
        }
        if designerBool {
            clickedPartArr = "디자이너"
        }
        if devBool {
            clickedPartArr = "개발자"
        }
        let userID = Auth.auth().currentUser!.uid
        ref.child(userID).child("userProfile").updateChildValues(["part":clickedPartArr])
        ref.child(userID).child("userProfile").updateChildValues(["partDetail":clckedDetailPart])
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension MyPartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == partTableview {
            return part.count
        }
        else if tableView == detailPartTableView {
            return detailPart.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == partTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "partCell", for: indexPath) as! CreateTeamPartTableViewCell
            cell.partLabel.text = part[indexPath.row]
            if didClicked[indexPath.row] == false {
                cell.backgroundColor = UIColor.clear
                cell.partLabel.textColor = UIColor.black
            }
            else {
                cell.backgroundColor = UIColor(named: "purple_247")
                cell.partLabel.textColor = UIColor(named: "purple_184")
            }
            return cell
        }
        else  {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "partDetailCell", for: indexPath) as! CreateTeamProfileDetailPartTableViewCell
            detailCell.partLabel.text = detailPart[indexPath.row]
        
            if clckedDetailPart.contains(detailPart[indexPath.row]) {
                detailCell.partLabel.textColor = UIColor(named: "purple_184")
                detailCell.checkImageView.isHidden = false
            }
            else {
                detailCell.backgroundColor = UIColor.clear
                detailCell.partLabel.textColor = UIColor.black
                detailCell.checkImageView.isHidden = true
            }
            return detailCell
        }
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == partTableview {
            let cell = tableView.cellForRow(at: indexPath)! as! CreateTeamPartTableViewCell
            if clickedPart.isEmpty == false {
                if clickedPart[0] == part[indexPath.row] {
                    cell.backgroundColor = UIColor.clear
                    cell.partLabel.textColor = UIColor.black
                }
                else {
                    clickedPart.removeAll()
                    clickedPart.append(part[indexPath.row])
                }
            }
            else {
                clickedPart.append(part[indexPath.row])
            }
           
            switch indexPath.row {
            case 0:
                // 기획자 선택할 경우
                num = 1
            case 1:
                // 디자이너 선택할 경우
                num = 2
            case 2:
                // 개발자 선택할 경우
                num = 3
            default:
                return
            }
            partTableview.reloadData()
        }
        else if tableView == detailPartTableView {
            
            let detai2Cell = tableView.cellForRow(at: indexPath)! as! CreateTeamProfileDetailPartTableViewCell
            let detail1 = tableView.cellForRow(at: [0,0])! as! CreateTeamProfileDetailPartTableViewCell
            let detail2 = tableView.cellForRow(at: [0,1])! as! CreateTeamProfileDetailPartTableViewCell
            let detail3 = tableView.cellForRow(at: [0,2])! as! CreateTeamProfileDetailPartTableViewCell
            let detail4 = tableView.cellForRow(at: [0,3])! as! CreateTeamProfileDetailPartTableViewCell
            let detail5 = tableView.cellForRow(at: [0,4])! as! CreateTeamProfileDetailPartTableViewCell
            
            if !detailPartDidClicked.isEmpty {
                if detailPartDidClicked[indexPath.row] == false {
                    
                    detailPartDidClicked[0] = false
                    detailPartDidClicked[1] = false
                    detailPartDidClicked[2] = false
                    
                    detail1.checkImageView.isHidden = true
                    detail2.checkImageView.isHidden = true
                    detail3.checkImageView.isHidden = true
                    detail4.checkImageView.isHidden = true
                    detail5.checkImageView.isHidden = true
                    
                    detail1.partLabel.textColor = UIColor.black
                    detail2.partLabel.textColor = UIColor.black
                    detail3.partLabel.textColor = UIColor.black
                    detail4.partLabel.textColor = UIColor.black
                    detail5.partLabel.textColor = UIColor.black
                    
                    detailPartDidClicked[indexPath.row] = true
                    detai2Cell.checkImageView.isHidden = false
                    detai2Cell.partLabel.textColor = UIColor(named: "purple_184")
                    clckedDetailPart = detai2Cell.partLabel.text!
                }
                else {
                    detailPartDidClicked[indexPath.row] = false
                    detai2Cell.checkImageView.isHidden = true
                    detai2Cell.partLabel.textColor = UIColor.black
                    clckedDetailPart = ""
                }
                
            }
            else {
                num = 1
                detailPartDidClicked[indexPath.row] = true
                detai2Cell.checkImageView.isHidden = false
                detai2Cell.partLabel.textColor = UIColor(named: "purple_184")
                clckedDetailPart = detai2Cell.partLabel.text!
            }
            
        }
        print(clckedDetailPart)
    }
}
protocol PartDataDelegate {
    func send(_ vc: UIViewController, Input value : String?)
}
