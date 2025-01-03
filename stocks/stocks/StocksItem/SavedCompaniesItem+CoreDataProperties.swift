//
//  SavedCompanies+CoreDataProperties.swift
//  stocks
//
//  Created by Nursultan Turekulov on 02.01.2025.
//
//

import Foundation
import CoreData


extension SavedCompaniesItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedCompaniesItem> {
        return NSFetchRequest<SavedCompaniesItem>(entityName: "SavedCompaniesItem")
    }

}

extension SavedCompaniesItem : Identifiable {

}
