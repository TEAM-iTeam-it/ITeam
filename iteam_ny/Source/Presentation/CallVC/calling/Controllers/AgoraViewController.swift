//
//  AgoraViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/26.
//

import UIKit

class AgoraViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var channelButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var name: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = "speaker"
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    @IBAction func textChanged(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChannelViewController" {
            let vc = segue.destination as! ChannelViewController
            vc.name = name
        }
    }
    @IBAction func joinChannel(_ sender: UIButton) {
        performSegue(withIdentifier: "showChannelViewController", sender: nil)
    }
    
}
