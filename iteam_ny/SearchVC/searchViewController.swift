//
//  searchViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

//import UIKit
//
//class searchViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var bounds = UIScreen.main.bounds
//                var width = bounds.size.width //화면 너비
//                let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
//                searchBar.placeholder = "이름,이메일 혹은 키워드로 검색"
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
//
//    }
//}
import UIKit
import Tabman
import Pageboy

class searchViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    var viewControllers: Array<UIViewController> = []
    @IBOutlet weak var searchTabBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        var bounds = UIScreen.main.bounds
                var width = bounds.size.width //화면 너비
                let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
                searchBar.placeholder = "이름,이메일 혹은 키워드로 검색"
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        let PersonResultVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonResultVC") as! PersonResultViewController
        let TeamResultVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamResultVC") as! TeamResultViewController
        viewControllers.append(PersonResultVC)
        viewControllers.append(TeamResultVC)

        dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar) //함수 추후 구현
        addBar(bar, dataSource: self, at: .custom(view: searchTabBar, layout: nil))
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
            button.selectedTintColor = UIColor(named: "purple_184")
            button.font = UIFont.systemFont(ofSize: 16)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        // 인디케이터
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = UIColor(named: "purple_184")
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
