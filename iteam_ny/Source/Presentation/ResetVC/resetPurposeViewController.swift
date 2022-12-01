//
//  resetPurposeViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/04/26.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class resetPurposeViewController: UIViewController {
    
    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
    // 목적 저장을 위한 변수
    var purposes: [String] = []
    
    // 목적 버튼
    @IBOutlet var purposeBtns: [UIButton]!
    @IBOutlet weak var portfolioImg: UIImageView!
    @IBOutlet weak var contestImg: UIImageView!
    @IBOutlet weak var hackathonImg: UIImageView!
    @IBOutlet weak var startupImg: UIImageView!
    @IBOutlet weak var etcImg: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveBtn.isEnabled = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        for i in 0...4{
            purposeBtns[i].layer.cornerRadius = 16
        }
    }
    @IBAction func purposeBtn(_ sender: UIButton) {
        if purposes.contains((sender.titleLabel?.text)!) {
            switch sender.titleLabel?.text {
            case "포트폴리오":
                portfolioImg.image = nil
            case "공모전":
                contestImg.image = nil
            case "해커톤":
                hackathonImg.image = nil
            case "창업":
                startupImg.image = nil
            default:
                etcImg.image = nil
            }
            sender.backgroundColor = UIColor(named: "gray_245")
            sender.setTitleColor(UIColor(named: "gray_121"), for: .normal)
            sender.layer.borderWidth = 0
            
            
            
            if let firstIndex = purposes.firstIndex(of: (sender.titleLabel?.text)!) {
                purposes.remove(at: firstIndex)
                print(firstIndex)
                
                // 3순위를 2순위로 바꿈
                print("aaaa")
                if purposes.count >= 1 {
                    switch purposes[0] {
                    case nil: break
                    case "포트폴리오":
                        portfolioImg.image = UIImage(systemName: "1.circle.fill")
                    case "공모전":
                        contestImg.image = UIImage(systemName: "1.circle.fill")
                    case "해커톤":
                        hackathonImg.image = UIImage(systemName: "1.circle.fill")
                    case "창업":
                        startupImg.image = UIImage(systemName: "1.circle.fill")
                    default:
                        etcImg.image = UIImage(systemName: "1.circle.fill")
                }
                }
                if purposes.count >= 2 {
                    switch purposes[1] {
                    case nil:
                        break
                    case "포트폴리오":
                        portfolioImg.image = UIImage(systemName: "2.circle.fill")
                    case "공모전":
                        contestImg.image = UIImage(systemName: "2.circle.fill")
                    case "해커톤":
                        hackathonImg.image = UIImage(systemName: "2.circle.fill")
                    case "창업":
                        startupImg.image = UIImage(systemName: "2.circle.fill")
                    default:
                        etcImg.image = UIImage(systemName: "2.circle.fill")
                    }
                }
                
            }
        }
        else {
            if purposes.isEmpty == true {
                switch sender.titleLabel?.text {
                case "포트폴리오":
                    portfolioImg.image = UIImage(systemName: "1.circle.fill")
                case "공모전":
                    contestImg.image = UIImage(systemName: "1.circle.fill")
                case "해커톤":
                    hackathonImg.image = UIImage(systemName: "1.circle.fill")
                case "창업":
                    startupImg.image = UIImage(systemName: "1.circle.fill")
                default:
                    etcImg.image = UIImage(systemName: "1.circle.fill")
                }
                sender.backgroundColor = UIColor(named: "purple_247")
                sender.layer.borderWidth = 0.5
                sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
                sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                
                
                purposes.append((sender.titleLabel?.text)!)
            }
            else if purposes.count == 1 {
                switch sender.titleLabel?.text {
                case "포트폴리오":
                    portfolioImg.image = UIImage(systemName: "2.circle.fill")
                case "공모전":
                    contestImg.image = UIImage(systemName: "2.circle.fill")
                case "해커톤":
                    hackathonImg.image = UIImage(systemName: "2.circle.fill")
                case "창업":
                    startupImg.image = UIImage(systemName: "2.circle.fill")
                default:
                    etcImg.image = UIImage(systemName: "2.circle.fill")
                }
                sender.backgroundColor = UIColor(named: "purple_247")
                sender.layer.borderWidth = 0.5
                sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
                sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                
                purposes.append((sender.titleLabel?.text)!)
            }
            else if purposes.count == 2 {
                switch sender.titleLabel?.text {
                case "포트폴리오":
                    portfolioImg.image = UIImage(systemName: "3.circle.fill")
                case "공모전":
                    contestImg.image = UIImage(systemName: "3.circle.fill")
                case "해커톤":
                    hackathonImg.image = UIImage(systemName: "3.circle.fill")
                case "창업":
                    startupImg.image = UIImage(systemName: "3.circle.fill")
                default:
                    etcImg.image = UIImage(systemName: "3.circle.fill")
                }
                sender.backgroundColor = UIColor(named: "purple_247")
                sender.layer.borderWidth = 0.5
                sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
                sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                
                purposes.append((sender.titleLabel?.text)!)
            }
        }
        if purposes.count >= 1 {
            saveBtn.tintColor = UIColor(named: "purple_184")
            saveBtn.isEnabled = true
        }
        else {
            saveBtn.isEnabled = false
        }

        print(purposes)
        
    }
    
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePurpose(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        var purposeString: String = ""
        for i in 0..<purposes.count {
            if i == purposes.count-1 {
                purposeString += purposes[i]
            }
            else {
                purposeString += "\(purposes[i]), "
            }
        }
        let values: [String: String] = [ "purpose": purposeString]
        
        ref = Database.database().reference()
        // [ 목적 데이터 추가 ]
        ref.child("user").child(user.uid).child("userProfileDetail").updateChildValues(values)
        navigationController?.popViewController(animated: true)
    }
}
