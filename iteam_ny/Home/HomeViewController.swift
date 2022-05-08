//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class HomeViewController: UIViewController, PickpartDataDelegate{
    
    @IBOutlet weak var myPart: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberStackVIew: UIStackView!
    var text:String = ""
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBAction func addEntry(_ sender: UIButton) {
        
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let alertPopupVC = stroyboard.instantiateViewController(withIdentifier: "PopupViewController") as!PopupViewController
        
        alertPopupVC.modalPresentationStyle = .overCurrentContext
        alertPopupVC.modalTransitionStyle = .crossDissolve
        alertPopupVC.delegate = self
        
        self.present(alertPopupVC, animated: true, completion: nil)
        
        }
    
    func makeButton(){
        guard let addButtonContainerView = memberStackVIew.arrangedSubviews.last else {
            fatalError("Expected at least one arranged view in the stack view")
        }
        // add button 한 칸 앞 index를 가져 온다
        let nextEntryIndex = memberStackVIew.arrangedSubviews.count - 1

        // scrollview의 스크롤이 이동할 위치계산
        let offset = CGPoint(x: scrollView.contentOffset.x + addButtonContainerView.bounds.size.width , y:
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
        pickimage.setTitle(text, for: .normal)
    // 현재날 짜는 짧게(M/D/Y) 가져온다
//    let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
//    // uuid를 가져온다
//    let number = NSUUID().uuidString
    // 스택뷰를 만들고
    // 각 속성을 아래와 같이 한다.
    // IB에서 하는 것과 같다
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 3

    // 날짜르 표시해줄 Label를 만든다
//    let dateLabel = UILabel()
//    dateLabel.text = date
//    dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
//    // uuid를 만들 Label을 만든다
//    let numberLabel = UILabel()
//    numberLabel.text = number
//    numberLabel.font = UIFont.preferredFont(forTextStyle: .headline)

    //stack 뷰에 차례대로 쌓는다.
        stack.addArrangedSubview(pickimage)
//    stack.addArrangedSubview(dateLabel)
//    stack.addArrangedSubview(numberLabel)
    return stack
    }
    
    func SendCategoryData(data: String) {
        if data == "개발자"{
            text = "개발자"
            makeButton()
           
        }
        if data == "디자이너"{
            text = "디자이너"
            makeButton()
            
        }
        if data == "기획자"{
            text = "기획자"
            makeButton()
        }
    }

    var ref: DatabaseReference! //Firebase Realtime Database
    
    var userList: [Uid] = []
    //알고리즘 - 진행중
    var userprofileDetail: UserProfileDetail?
//    var image = [UIImage(named: "imgUser4"),UIImage(named: "imgUser5"),UIImage(named: "imgUser4"),UIImage(named: "imgUser5"),UIImage(named: "imgUser5")]
    
   //알고리즘 - 진행중
    func sortList(a:Int, b:Int) -> Bool {
        let celebrity1: [String] = ["창의적인", "상상력이 풍부한", "전통에 얽매이지 않는" ]
        let celebrity2: [String] = ["외향적인", "열정적인", "사교성이 있는" ]
        let celebrity3: [String] = ["자신감 있는", "의사 결정을 잘하는", "목표 지향적인"]
        let celebrity4: [String] = ["문제를 극복하는", "도전적인", "추진력있는"]
        let celebrity5: [String] = ["전략적인", "신중한", "정확히 판단하는"]
        let detail = userprofileDetail
        let char = detail?.character

        let charindex: [String] = (char?.components(separatedBy: ", "))!
        let f = charindex[0]
        let s = charindex[1]
        let l = charindex[2]
        
        //나의 성향 출력
        if let firstIndex = celebrity1.firstIndex(of: f) {
            print("창의적인")
        }
        for mych in charindex {
            if let firstIndex = celebrity1.firstIndex(of: mych) {
                print("창의적인")
            }
        }

        
        return a>b
        
    }
       
        override func viewDidLoad() {
            super.viewDidLoad()
           
            ref = Database.database().reference().child("user")
            
           // 내정보 가져오기
            let currentUser = Auth.auth().currentUser
            ref.child((currentUser?.uid)!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let partDetail = value?["partDetail"] as? String ?? ""

                self.myPart.text = "\(partDetail)"
                
            }) { error in
              print(error.localizedDescription)
            }
            
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
                    
                    //
                    
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
            cell.school.text = "\(userList[indexPath.row].userProfile.schoolName)"
            cell.partLabel.text = "\(userList[indexPath.row].userProfile.partDetail) • "
            cell.userPurpose.text = "\(userList[indexPath.row].userProfileDetail.purpose)"
            
        //gs://iteam-test.appspot.com/user_profile_image/AgXjS1Qu5DM8CHMPFqabDeFmgG92.jpg
//            var url2 = "gs://iteam-test.appspot.com/user_profile_image/"
//            let imageURL = URL(string: userList[indexPath.row].userImageURL)
//            cell.userImage.kf.setImage(with: imageURL)
//            cell.userImage.kf.setImage(with: imageURL)
            //kingfisher
//            var url:[String] = ["gs://iteam-test.appspot.com/user_profile_image/8LpKA1ngmnOoLYlqJTyTqovAk6r1.jpg","gs://iteam-test.appspot.com/user_profile_image/BApgRw1uC5aaCFhIndjvZUf5ba22.jpg", "gs://iteam-test.appspot.com/user_profile_image/AgXjS1Qu5DM8CHMPFqabDeFmgG92.jpg",
//            "gs://iteam-test.appspot.com/user_profile_image/ioyypRfWH5SryhVvJwvxZxxcyMF3.jpg","gs://iteam-test.appspot.com/user_profile_image/bj2kJjtateXp5mp9KGLoHtyOZ183.jpg"]
//            var url = "gs://iteam-test.appspot.com/user_profile_image/"
//            let uid: String = "7DNtefn5EBPbSI8By0g1IeVS0Jg1"
//            let url1 = url + uid + ".jpg"
//            print(url1)
//            let imageURL = URL(string: userList[indexPath.row].userImageURL)
//            let imageURL = URL(string: url[indexPath.row])
//            let imageURL = URL(string: url1)
//            cell.userImage.kf.setImage(with: imageURL)
            
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

