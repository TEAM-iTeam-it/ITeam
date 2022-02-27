//
//  CallManageViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/01.
//

import UIKit
import Tabman
import Pageboy

class CallManageViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    var viewControllers: Array<UIViewController> = []
    @IBOutlet weak var tabBarView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let CallAnswerVC = UIStoryboard.init(name: "JoinPages", bundle: nil).instantiateViewController(withIdentifier: "CallAnswerVC") as! CallAnswerViewController
        let CallRequestVC = UIStoryboard.init(name: "JoinPages", bundle: nil).instantiateViewController(withIdentifier: "CallRequestVC") as! CallRequestViewController
        viewControllers.append(CallAnswerVC)
        viewControllers.append(CallRequestVC)

        
        dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        // Do any additional setup after loading the view.
    }
    
    // 상단 커스텀 탭바 setting
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "개인")
        case 1:
            return TMBarItem(title: "팀")
        default:
            return TMBarItem(title: "\(index)")
        }
    }

    
    // 커스텀 탭바 세팅
    func settingTabBar(ctBar: TMBar.ButtonBar) {
        ctBar.layout.transitionStyle = .snap
        // 왼쪽 여백주기
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // 간격
        ctBar.layout.interButtonSpacing = 0
            
        ctBar.backgroundView.style = .blur(style: .light)
        // 콘텐츠 모드
        ctBar.layout.alignment = .centerDistributed
        ctBar.layout.contentMode = .fit
        
        // 선택 / 안선택 색 + font size
        ctBar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = UIColor(named: "purple_dark")
            button.font = UIFont.systemFont(ofSize: 16)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        // 인디케이터
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = UIColor(named: "purple_dark")
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
