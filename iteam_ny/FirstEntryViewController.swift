//
//  FirstEntryViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/15.
//

import UIKit
import FirebaseAuth

class FirstEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    // 가입한 유저인지 체크
    func checkDidJoined() {
        // 임시 수정 != -> ==
        if Auth.auth().currentUser == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = storyboard.instantiateInitialViewController() as? TabarController  {
               
                tabBarVC.modalPresentationStyle = .fullScreen
                present(tabBarVC, animated: false, completion: nil)
                print("자동 로그인 성공~")
            }
            print(Auth.auth().currentUser?.uid)
        }
        else {
            // 임시 수정 != -> ==
//            let storyboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
//            if let viewController = storyboard.instantiateInitialViewController() as? JoinViewController  {
//
//                viewController.modalPresentationStyle = .fullScreen
//                present(viewController, animated: false, completion: nil)
//                print("가입되지 않은 사용자~~")
//            }
            let storyboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
            if let viewController = storyboard.instantiateInitialViewController() as? UINavigationController  {
               
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: false, completion: nil)
                print("가입되지 않은 사용자~~")
            }
        }
        
    }
}
