//
//  SavedCompanies+CoreDataClass.swift
//  stocks
//
//  Created by Nursultan Turekulov on 02.01.2025.
//
//

import Foundation
import CoreData
import UIKit

@objc(SavedCompaniesItem)
public class SavedCompaniesItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var abbreviation: String
    @NSManaged var logoData: Data
    @NSManaged var price: Double
    @NSManaged var isFavourite: Bool
    
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
