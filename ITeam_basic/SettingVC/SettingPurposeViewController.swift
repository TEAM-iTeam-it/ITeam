//
//  SettingPurposeViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/21.
//

import UIKit

class SettingPurposeViewController: UIViewController {

    // 목적 저장을 위한 변수
    var purposes: [String] = []
    
    // 목적 버튼
    @IBOutlet var purposeBtns: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...purposeBtns.count-1 {
            purposeBtns[i].setImage(nil, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func purposeBtn(_ sender: UIButton) {
        if purposes.contains((sender.titleLabel?.text)!) {
            sender.imageView?.isHidden = true
            if let firstIndex = purposes.firstIndex(of: (sender.titleLabel?.text)!) {
                if firstIndex == 1 {
                    // 3순위를 2순위로 바꿈
                    
                }
                purposes.remove(at: firstIndex)
                print(firstIndex)
            }
        }
        else {
            if purposes.isEmpty == true {
                sender.imageView?.isHidden = false
                sender.setImage(UIImage(systemName: "1.circle.fill"), for: .normal)
                sender.configuration?.imagePadding = 130
                sender.configuration?.contentInsets.trailing = 168
                
                purposes.append((sender.titleLabel?.text)!)
            }
            else if purposes.count == 1 {
                sender.imageView?.isHidden = false
                sender.setImage(UIImage(systemName: "2.circle.fill"), for: .normal)
                sender.configuration?.imagePadding = 130
                sender.configuration?.contentInsets.trailing = 168
                
                purposes.append((sender.titleLabel?.text)!)
            }
            else if purposes.count == 2 {
                sender.imageView?.isHidden = false
                sender.setImage(UIImage(systemName: "3.circle.fill"), for: .normal)
                sender.configuration?.imagePadding = 130
                sender.configuration?.contentInsets.trailing = 168
                
                purposes.append((sender.titleLabel?.text)!)
            }
        }
        

        print(purposes)
        
    }
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
