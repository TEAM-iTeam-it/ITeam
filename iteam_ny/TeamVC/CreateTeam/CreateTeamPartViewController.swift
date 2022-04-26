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
    @IBOutlet weak var chipCollectionView: UICollectionView!
    
    @IBOutlet weak var partNavigationBar: UINavigationBar!
    
    var delegate: SendPartDataDelegate?
    
    let part: [String] = ["기획자", "디자이너", "개발자"]
    var detailPart: [String] = []
    var plannerDetailPart: [String] = ["앱 기획자", "웹 기획자", "게임 기획자"]
    var designerDetailPart: [String] = ["UI/UX 디자이너", "일러스트레이터", "모델러"]
    var devDetailPart: [String] = ["Android 개발", "iOS 개발", "웹 개발", "백엔드 개발", "게임 개발"]
    var didClicked: [Bool] = [false, false, false]
    var detailPartDidClicked: [Bool] = []
    var clickedPart: [String] = []
    var clckedDetailPart: [String] = []
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
    
    // 칩을 위한 변수
    var parts: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partTableview.separatorStyle = .none
        detailPartTableView.separatorStyle = .none
        partNavigationBar.shadowImage = UIImage()
        detailPart = plannerDetailPart
        self.chipCollectionView.delegate = self
        self.chipCollectionView.dataSource = self
        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: Any) {
        delegate?.sendData(data: clckedDetailPart)
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
            
            
            if detailPartDidClicked[indexPath.row] == false {
                detailPartDidClicked[indexPath.row] = true
                
                detai2Cell.checkImageView.isHidden = false
                detai2Cell.partLabel.textColor = UIColor(named: "purple_184")
                
                
                if clckedDetailPart.contains(detai2Cell.partLabel.text!) {
                    
                }
                else {
                    clckedDetailPart.append(detai2Cell.partLabel.text!)
                    print("detailCell : \(detai2Cell.partLabel.text!)")
                }
            }
            else {
                detailPartDidClicked[indexPath.row] = false
                detai2Cell.checkImageView.isHidden = true
                detai2Cell.partLabel.textColor = UIColor.black
                for i in 0...clckedDetailPart.count-1 {
                    if clckedDetailPart[i] == detai2Cell.partLabel.text {
                        clckedDetailPart.remove(at: i)
                        break
                    }
                }
            }
            chipCollectionView.reloadData()
            
            
        }
        parts = clckedDetailPart
        print(clckedDetailPart)
    }
}
extension CreateTeamPartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partNameCell", for: indexPath) as! CreateTeamProfilePartCollectionViewCell
        cell.partName.setTitle(parts[indexPath.row], for: .normal)
        
        cell.partName.layer.borderColor = UIColor(named: "purple_184")?.cgColor
        cell.partName.tintColor = UIColor(named: "purple_184")
        
        cell.partName.layer.borderWidth = 0.5
        cell.partName.layer.cornerRadius = cell.frame.height/2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = parts[indexPath.item]
        
        label.font = UIFont(name: "Apple SD 산돌고딕 Neo 일반체", size: 14.0)
        label.sizeToFit()
        let size = label.frame.size
        
        
        return CGSize(width: size.width+30, height: size.height + 6)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("지우자")
        clckedDetailPart.remove(at: indexPath.row)
        parts = clckedDetailPart
        
        collectionView.reloadData()
        detailPartTableView.reloadData()
    }
    
}
protocol SendPartDataDelegate {
    func sendData(data: [String])
}
