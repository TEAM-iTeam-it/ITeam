//
//  MyFriendListViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/06/02.
//

import UIKit

class MyFriendListViewController:UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        
        let fancyImage = UIImage(systemName:"arrow.left")

        var fancyAppearance = UINavigationBarAppearance()
        fancyAppearance.backgroundColor = UIColor.white
        fancyAppearance.setBackIndicatorImage(fancyImage, transitionMaskImage: fancyImage)

        navigationController?.navigationBar.scrollEdgeAppearance = fancyAppearance
    }
        
}


