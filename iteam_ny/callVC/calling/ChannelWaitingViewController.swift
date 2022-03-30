//
//  ChannelWaitingViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit

class ChannelWaitingViewController: UIViewController {

    var nickname: String = ""
    var position: String = ""
    var name: String = ""
    var profile: String = ""
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        nicknameLabel.text = nickname
        positionLabel.text = position
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.image = UIImage(named: "\(profile).png")
        
        name = "speaker"
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChannelViewController" {
            let vc = segue.destination as! ChannelViewController
            vc.name = name
            
            if let destination = segue.destination as? ChannelViewController {
                destination.nickname = nickname
                destination.position = position
            }
        }
        if segue.identifier == "showQuestionVC" {
            let vc = segue.destination as! QuestionnaireViewController
            vc.nickname = nickname
        }
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
