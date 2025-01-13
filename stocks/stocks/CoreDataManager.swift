//
//  CoreDataManager.swift
//  stocks
//
//  Created by Алдияр Есимханов on 09.01.2025.
//

import Foundation
import UIKit

final  class CoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var companies: [CompanyItem] = []
    var favouriteCompanies: [FavouriteCompanyItem] = []
    func createItem(company: Company) {
        let newCompany = CompanyItem(context: context)
        newCompany.name = company.name
        newCompany.abbreviation = company.abbreviation
        newCompany.logo = company.logo
        newCompany.isFavourite = company.isFavourite
        newCompany.price = company.price
        newCompany.change = company.change
        companies.append(newCompany)
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func createFavouriteItem(company: CompanyItem) {
        let newCompany = FavouriteCompanyItem(context: context)
        newCompany.name = company.name
        newCompany.abbreviation = company.abbreviation
        newCompany.logo = company.logo
        newCompany.isFavourite = company.isFavourite
        newCompany.price = company.price
        newCompany.change = company.change
        favouriteCompanies.append(newCompany)
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func deleteItemFromFavourite(item: FavouriteCompanyItem, index: Int) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("object does not deleted from coredata")
        }
        favouriteCompanies.remove(at: index)
    }
    
    func deleteItemFromCompanies(item: CompanyItem, index: Int) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("object does not deleted from coredata")
        }
        companies.remove(at: index)
    }
    
    func getAllCompanies() {
        do {
            companies = try context.fetch(CompanyItem.fetchRequest())
        } catch {
            print("Error in getAllItems, can not get items from database")
        }
    }
    func getFavouriteCompanies() {
        do {
            favouriteCompanies = try context.fetch(FavouriteCompanyItem.fetchRequest())
        } catch {
            print("Error in getAllItems, can not get items from database")
        }
    }
    
    func updateItem() {
        do {
            try context.save()
        } catch {
            print("object doesn't updated")
        }
    }
}
