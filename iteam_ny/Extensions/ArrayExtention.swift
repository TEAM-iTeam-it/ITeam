//
//  ArrayExtention.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/02.
//

import Foundation

// 두 array 값을 비교해주는 함수
extension Array where Element: Equatable {
    func diffIndicesNotConsideringOrder(from oldArray: [Element]) -> [Int] {
        self.indices.indices.compactMap { index in
            if !oldArray.contains(self[index]) {
                return index
            }
            return nil
        }
    }
}
