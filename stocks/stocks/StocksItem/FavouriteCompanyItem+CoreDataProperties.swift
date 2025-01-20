//
//  FavouriteCompanyItem+CoreDataProperties.swift
//  stocks
//
//  Created by Nursultan Turekulov on 02.01.2025.
//
//

import Foundation
import CoreData
import UIKit

extension FavouriteCompanyItem {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCompanyItem> {
        return NSFetchRequest<FavouriteCompanyItem>(entityName: "FavouriteCompanyItem")
    }
    
    @NSManaged public var name: String
    @NSManaged public var abbreviation: String
    @NSManaged public var logoData: Data
    @NSManaged public var price: Double
    @NSManaged public var isFavourite: Bool
    @NSManaged public var change: String
    
    var logo: UIImage? {
        get {
            guard let data = logoData as Data? else { return nil }
            return UIImage(data: data)
        }
        set {
            logoData = newValue?.pngData() ?? Data()
        }
    }
}

extension FavouriteCompanyItem : Identifiable {
    
}
