//
//  searchViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit

class searchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var bounds = UIScreen.main.bounds
                var width = bounds.size.width //화면 너비
                let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
                searchBar.placeholder = "이름,이메일 혹은 키워드로 검색"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
    }
}
