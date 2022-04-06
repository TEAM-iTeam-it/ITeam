//
//  CreateTeamPartViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/04.
//

import UIKit

class CreateTeamPartViewController: UIViewController {
    @IBOutlet weak var partTableview: UITableView!
    @IBOutlet weak var detailPartTableView: UITableView!
    
    
    let part: [String] = ["기획자", "디자이너", "개발자"]
    var detailPart: [String] = []
    var plannerDetailPart: [String] = ["앱 기획자", "웹 기획자", "게임 기획자"]
    var designerDetailPart: [String] = ["UI/UX 디자이너", "일러스트레이터", "모델러"]
    var devDetailPart: [String] = ["Android 개발", "iOS 개발", "웹 개발", "백엔드 개발", "게임 개발"]
    var didClicked: Bool = false
    var detailPartDidClicked: [Bool] = []
    var num: Int = 0 {
        willSet(newValue) {
            print(newValue)
            if newValue == 1 {
                detailPart = plannerDetailPart
                detailPartDidClicked.removeAll()
                for _ in 0..<plannerDetailPart.count {
                    detailPartDidClicked.append(false)
                }
            }
            else if newValue == 2 {
                detailPart = designerDetailPart
                detailPartDidClicked.removeAll()
                for _ in 0..<designerDetailPart.count {
                    detailPartDidClicked.append(false)
                }
            }
            else if newValue == 3 {
                detailPart = devDetailPart
                detailPartDidClicked.removeAll()
                for _ in 0..<devDetailPart.count {
                    detailPartDidClicked.append(false)
                }
            }
            detailPartTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailPart = plannerDetailPart
        

    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension CreateTeamPartViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "partCell", for: indexPath) as! CreateTeamPartTableViewCell
        if tableView == partTableview {
            cell.partLabel.text = part[indexPath.row]
            return cell
        }
        else if tableView == detailPartTableView {
            cell.partLabel.text = detailPart[indexPath.row]
            return cell
        }
        return cell
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == partTableview {
            let cell = tableView.cellForRow(at: indexPath)! as! CreateTeamPartTableViewCell
            if didClicked == false {
                didClicked = true
                cell.backgroundColor = UIColor(named: "purple_247")
                cell.partLabel.textColor = UIColor(named: "purple_184")
            }
            else {
                didClicked = false
                cell.backgroundColor = UIColor.clear
                cell.partLabel.textColor = UIColor.black
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
        }
        else if tableView == detailPartTableView {
            let cell = tableView.cellForRow(at: indexPath)! as! CreateTeamPartTableViewCell
            cell.partLabel.textColor = UIColor(named: "purple_184")
        }
    }
}
