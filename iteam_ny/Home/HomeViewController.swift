//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberStackVIew: UIStackView!

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBAction func addEntry(_ sender: UIButton) {
        
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let alertPopupVC = stroyboard.instantiateViewController(withIdentifier: "PopupViewController") as!PopupViewController
        
        alertPopupVC.modalPresentationStyle = .overCurrentContext
        alertPopupVC.modalTransitionStyle = .crossDissolve
        
        self.present(alertPopupVC, animated: true, completion: nil)
        
        // stack view에 있는 add button을 가져온다.
                guard let addButtonContainerView = memberStackVIew.arrangedSubviews.last else {
                    fatalError("Expected at least one arranged view in the stack view")
                }
                // add button 한 칸 앞 index를 가져 온다
                let nextEntryIndex = memberStackVIew.arrangedSubviews.count - 1

                // scrollview의 스크롤이 이동할 위치계산
                // 현 위치에서 add button의 높이 만큼 이레러
//                let offset = CGPoint(x: scrollView.contentOffset.x, y:
//        scrollView.contentOffset.y + addButtonContainerView.bounds.size.height)

        let offset = CGPoint(x:scrollView.contentOffset.x + addButtonContainerView.bounds.size.width , y:
                                scrollView.contentOffset.y)

                // stackview를 만들어서 안 보이게 처리
                let newEntryView = createEntryView()
                newEntryView.isHidden = true

                // 만들어진 stack view를 add button앞에다가 추가
        memberStackVIew.insertArrangedSubview(newEntryView, at: nextEntryIndex)

                // 0.25초 동안 추가된 뷰가 보이게 하면서 scrollview의 스크롤 이동
                UIView.animate(withDuration: 0.25) {
                    newEntryView.isHidden = false
                    self.scrollView.contentOffset = offset
                }
    }
    // 수직 스택뷰 안에 들어갈 수평 스택뷰들 만든다.
        private func createEntryView() -> UIView {
            
            let pickimage = UIButton()
            pickimage.widthAnchor.constraint(equalToConstant: 70).isActive = true
            // 버튼 넓이 300
            pickimage.heightAnchor.constraint(equalToConstant: 70).isActive = true
            pickimage.backgroundColor = UIColor.purple
            pickimage.layer.cornerRadius = 35
            // 현재날 짜는 짧게(M/D/Y) 가져온다
            let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
            // uuid를 가져온다
            let number = NSUUID().uuidString
            // 스택뷰를 만들고
            // 각 속성을 아래와 같이 한다.
            // IB에서 하는 것과 같다
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 3

            // 날짜르 표시해줄 Label를 만든다
            let dateLabel = UILabel()
            dateLabel.text = date
            dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
            // uuid를 만들 Label을 만든다
            let numberLabel = UILabel()
            numberLabel.text = number
            numberLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            // 이 label의 horizontal contenthugging을 249, compressionResistance 749로 해서 stackview의 남은 공간을 꽉 채우게 한다.
//            numberLabel.setContentHuggingPriority(UILayoutPriority.defaultLow - 1.0, for: .horizontal)
//            numberLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh - 1.0, for: .horizontal)
            //stack 뷰에 차례대로 쌓는다.
            stack.addArrangedSubview(pickimage)
            stack.addArrangedSubview(dateLabel)
            stack.addArrangedSubview(numberLabel)

            return stack
        }
    
    var ref: DatabaseReference! //Firebase Realtime Database
    
    var userList: [Uid] = []
//    var image = [UIImage(named: "imgUser4"),UIImage(named: "imgUser5"),UIImage(named: "imgUser4"),UIImage(named: "imgUser5"),UIImage(named: "imgUser5")]
       
        override func viewDidLoad() {
            super.viewDidLoad()
           
//            ref = Database.database().reference()
            ref = Database.database().reference().child("user")
            
            //UITableView Cell Register
            let nibName = UINib(nibName: "UserListCell", bundle: nil)
            homeTableView.register(nibName, forCellReuseIdentifier: "UserListCell")
            
            homeTableView.rowHeight = UITableView.automaticDimension
            homeTableView.estimatedRowHeight = 70
            
            self.homeTableView.panGestureRecognizer.delaysTouchesBegan = true
            
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            
            
            //데이터 가져오기
            ref.observe(.value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else { return }
                
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
//                    let userData = try JSONDecoder().decode([String: UserProfile].self, from: jsonData)
                    let userData = try JSONDecoder().decode([String: Uid].self, from: jsonData)
                    let showUserList = Array(userData.values)
                    self.userList = showUserList.sorted { $0.rank < $1.rank } //정렬 순서
                    
                    print("countentArray.cout : \(showUserList.count)")
                    
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                        print("countentArray3.cout : \(self.userList.count)")
                    }
                    
                }catch let DecodingError.dataCorrupted(context) {
                    print("error2 : ",context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                catch let error {
                    print("ERROR JSON parasing \(error.localizedDescription)")
                }
                
                print("countentArray2.cout : \(self.userList.count)")
                
            }
            
            
            homeTableView.layer.shadowColor = UIColor.black.cgColor // 색깔
            homeTableView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
            homeTableView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
            homeTableView.layer.shadowRadius = 5 // 반경
            homeTableView.layer.shadowOpacity = 0.3 // alpha값
            self.homeTableView.layer.cornerRadius = 20.0
            homeTableView.contentInset = UIEdgeInsets(top: 20, left: .zero, bottom: 10, right: .zero)
    //
            addFriendButton.layer.shadowColor = UIColor.black.cgColor // 색깔
            addFriendButton.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
            addFriendButton.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
            addFriendButton.layer.shadowRadius = 5 // 반경
            addFriendButton.layer.shadowOpacity = 0.3 // alpha값
            
            
       }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
       }
    
        
}


    extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
        
        //배열의 인덱수 수가 테이블 뷰의 row 수
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.userList.count
           }
       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell",for: indexPath) as? UserListCell else {return UITableViewCell()}
                
            cell.userName.text = "\(userList[indexPath.row].userProfile.nickname)"
            cell.school.text = "\(userList[indexPath.row].userProfile.schoolName)위"
            cell.partLabel.text = "\(userList[indexPath.row].userProfile.partDetail)\(userList[indexPath.row].userProfile.part)"
            cell.userPurpose.text = "\(userList[indexPath.row].userProfileDetail.purpose)"
            
               return cell
           }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            print("You selected cell #\(indexPath.row)!")
            //상세페이지 이동
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let detailViewController = storyboard.instantiateViewController(identifier: "UserProfileController") as? UserProfileController else { return }
            
            detailViewController.userprofileDetail = userList[indexPath.row].userProfileDetail
            detailViewController.userprofile = userList[indexPath.row].userProfile
            self.show(detailViewController, sender: nil)
            
        }
    }


    @IBDesignable class PaddingLabel: UILabel {

        @IBInspectable var topInset: CGFloat = 5.0
        @IBInspectable var bottomInset: CGFloat = 5.0
        @IBInspectable var leftInset: CGFloat = 8.0
        @IBInspectable var rightInset: CGFloat = 8.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        
        override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
        }
}

