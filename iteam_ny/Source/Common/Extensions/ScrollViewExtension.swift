//
//  ScrollViewExtension.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/17.
//

import Foundation
import UIKit

// 텍스트필드 클릭시 키보드 위로 스크롤 올리기
public enum ScrollDirection {
    case top
    case center
    case bottom
    case bottom250
}

public extension UIScrollView {
    func scroll(to direction: ScrollDirection) {
        
        DispatchQueue.main.async {
            switch direction {
            case .top:
                self.scrollToTop()
            case .center:
                self.scrollToCenter()
            case .bottom:
                self.scrollToBottom()
            case .bottom250:
                self.scrollToBottom250()
            }
        }
    }
    
    private func scrollToTop() {
        setContentOffset(.zero, animated: true)
    }
    
    private func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: true)
    }
    
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    private func scrollToBottom250() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height+250 + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
