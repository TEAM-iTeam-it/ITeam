//
//  SearchViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/30.
//

import UIKit

class SearchViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true // <- 이코드가 꼭 있어야함 } //다른 뷰에서 tabBar를 다시 보이게 하고 싶으면(viewWillAppear)에 false를 해주자
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.tabBarController?.tabBar.isHidden = false
            
        }

    
}
