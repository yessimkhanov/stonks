//
//  CoreDataManager.swift
//  stocks
//
//  Created by Алдияр Есимханов on 09.01.2025.
//

import Foundation
import UIKit

final class CoreDataManager {
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
            print(error)
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
            print(error)
        }
    }
    
    func starButtonPressed(companyName: String) {
        guard let index = companies.firstIndex(where: {$0.name == companyName}) else {
            print("Error in finding a company inside a coreData")
            return
        }
        if let favoriteIndex = favouriteCompanies.firstIndex(where: {$0.name == companyName}) {
            companies[index].isFavourite.toggle()
            deleteItemFromFavourite(item: favouriteCompanies[favoriteIndex], index: favoriteIndex)
        } else {
            companies[index].isFavourite.toggle()
            createFavouriteItem(company: companies[index])
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
