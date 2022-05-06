//
//  FavorTeam+CoreDataProperties.swift
//  
//
//  Created by 김하늘 on 2022/04/27.
//
//

import Foundation
import CoreData


extension FavorTeam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavorTeam> {
        return NSFetchRequest<FavorTeam>(entityName: "FavorTeam")
    }

    @NSManaged public var favorTeam: [String]?

}
