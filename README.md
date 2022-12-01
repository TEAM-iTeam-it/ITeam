# iteam

<img width="139" alt="image" src="https://user-images.githubusercontent.com/63438947/205021199-0162436d-651b-4acd-9e1d-77ab3c51aeae.png">

### IT 프로젝트 팀 빌딩 과정을 돕는 앱, **iteam**
 성공적인 프로젝트의 시작, iteam에서 함께 하세요!

---

<!---
## ****Contributors****

|<img width="205" alt="image" src="https://user-images.githubusercontent.com/68391767/178255375-e15e8358-57f8-454d-978f-fee9f72f6f7d.png">|나연 사진|
|:--:|:--:|
|김하늘|성나연|
|통화 탭, 팀탭 구현|홈탭, 알림탭 구현|
|khnpoq@gmail.com|나연 이메일|
-->

## ****Project Setting****

### 🏄‍♂️ ****Development Environment****

| Environment | Tool | Tag | Based on |
| --- | --- | --- | --- |
| Framework | UIKit | Layout |  |
| Library | Firebase RealTime Database | Network| 실시간 데이터베이스 사용 |
|  | Pageboy | Layout | 자연스러운 상단 탭바 구현 |
|  | Kingfisher | Image Caching | 편리하고 빠른 이미지 캐싱 처리 |
| API | Agora API | Real-time Voice Calling | 실시간 통화 기능 제공 |

### 🏄‍♂️  ****Convention****

[Code Convention (base idea)](https://octoberproduct.notion.site/Code-Convention-base-idea-c69784d0a44c4c65b23a4f77dbe36622) <br>
[Code Convention](https://octoberproduct.notion.site/Code-Convention-74fb1be79b4f43c6a544ed18504bec61)
  
  

## 🏄‍♂️ ****Git****

[Git Flow, Git Convention](https://octoberproduct.notion.site/Git-Flow-Git-Convention-af7f4a44996e48e4b2dc4e58a16674eb)
  
  

## 🏄‍♂️ Branch Naming

- `add (default)`: 합치는 공간
- `feat/#이슈번호-기능설명-이름` : 기능을 개발하는 브랜치
    - 이슈별•작업별로 브랜치를 생성하여 기능을 개발함.
    - ex) feat/#32-homeUI-jy
- `fix/#이슈번호-기능설명-이름` : 버그를 수정하는 브랜치
  
  

## 🏄‍♂️ ****Folder Structure****

```
├── Info.plist
├── Resource
│   ├── Assets
│   │   └── AppIcon.xcassets
│   ├── Colors
│   │      └── Colors.xcassets
│   ├── Fonts
│   └── Storyboards // LaunchScreen
├── Source
│   ├── Application
│   │   └── AppDelegate
│   │   └── SceneDelegate
│   ├── Common
│   │   └── Consts
│   │   └── Extensions
│   │   └── Protocols
│   ├── Presentation
│   │   └── Common
│   │			└── Button // ex) PhotoSurferSearchButton.swift
│   │			└── TextField
│   │   └── Home// 뷰 별로 나누기
│   │        └── Views // ex) Home.storyboard
│   │             └── Cells // ex) HomeTableViewCell.xib
│   │        └── Controllers // ex) HomeViewController+Extension.swift
│   ├── Service
│   │   └── Data
│   │        └── Model
│   │   └── Network
│   │        └── DTO // API별
└───
```

