//
//  DetailProfileExTableView.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/11.
//

import UIKit

class DetailProfileExTableView: UITableView {
    
    // 셀 높이에 따라 tableview높이 지정
    override var intrinsicContentSize: CGSize {
        let sectionNum = numberOfSections
        var height: CGFloat = 0
        var totalHeight: CGFloat = 0

        print(sectionNum)
        if sectionNum != 0 {
            let number = numberOfRows(inSection: 0)
            for i in 0..<number {
                guard let cell = cellForRow(at: IndexPath(row: i, section: 0)) else {
                    continue
                }
                height += cell.bounds.height
            }            
        }
        
        // 높이 = 첫번째 섹션의 셀 높이(모든 섹션에 한 셀인 상태) + (섹션 개수 * 10(=footer크기) + footer회색 바 보이지 않도록 여분)
        totalHeight = (height * CGFloat(sectionNum)) + (CGFloat(sectionNum) * 10) + 3.0
        return CGSize(width: contentSize.width, height: totalHeight)
    }
}
