
import Foundation
import UIKit
import CoreData

enum StateOfButton {
    case stocks
    case favourite
}

protocol StocksPresenterProtocol: AnyObject {
    var currentState: StateOfButton { get }
    func viewDidLoad()
    func stocksButtonPressed()
    func favouriteButtonPressed()
    func numberOfRows() -> Int
    func deleteCompany(index: Int)
    func companyForRow(at index: Int) -> Company
    func starButtonPressed(at index: Int, isFavourite: Bool)
    func addCompany(_ companyToAdd: String)
    func getPopularCompany(at index: Int) -> String
}

final class StocksPresenter: StocksPresenterProtocol {
    let popularRequestsCompanies: [String] = ["Apple", "Amazon", "Google", "Visa", "American Airlines LLC.", "Garmin LTD"]
    private weak var view: ViewProtocol?
    private var dataSource: CompanyDataSource
    var currentState: StateOfButton = .stocks
    private var manager: StocksManager
    private var context: NSManagedObjectContext
    private var companies: [CompanyItem] = []
    private var favouriteCompanies: [FavouriteCompanyItem] = []
    init(view: ViewProtocol, dataSource: CompanyDataSource, manager: StocksManager, context: NSManagedObjectContext) {
        self.view = view
        self.dataSource = dataSource
        self.manager = manager
        self.context = context
    }
    
    func viewDidLoad() {
        getAllCompanies()
        getFavouriteCompanies()
        view?.reloadTableView()
    }
    
    func stocksButtonPressed() {
        guard currentState != .stocks else { return }
        currentState = .stocks
        view?.updateButtonStyles(for: .stocks)
        view?.reloadTableView()
    }
    
    func favouriteButtonPressed() {
        guard currentState != .favourite else { return }
        currentState = .favourite
        view?.updateButtonStyles(for: .favourite)
        view?.reloadTableView()
    }
    
    func numberOfRows() -> Int {
        switch currentState {
        case .stocks:
            return companies.count
        case .favourite:
            return favouriteCompanies.count
        }
    }
    
    func deleteCompany(index: Int) {
        switch currentState {
        case .stocks:
            if companies[index].isFavourite {
                if let favIndex = favouriteCompanies.firstIndex(where: { $0.name == companies[index].name }) {
                    deleteItemFromFavourite(item: favouriteCompanies[favIndex], index: favIndex)
                }
            }
            deleteItemFromCompanies(item: companies[index], index: index)
            
        case .favourite:
            let favouriteItem = favouriteCompanies[index]
            if let compIndex = companies.firstIndex(where: { $0.name == favouriteItem.name }) {
                deleteItemFromCompanies(item: companies[compIndex], index: compIndex)
            }
            deleteItemFromFavourite(item: favouriteItem, index: index)
        }
    }
    
    
    func companyForRow(at index: Int) -> Company {
        switch currentState {
        case .stocks:
            let companyToReturn = Company(
                name: companies[index].name,
                abbreviation: companies[index].abbreviation,
                logo: companies[index].logo ?? UIImage(named: "Kaspi")!,
                price: companies[index].price,
                isFavourite: companies[index].isFavourite
            )
            return companyToReturn
        case .favourite:
            let companyToReturn = Company(
                name: favouriteCompanies[index].name,
                abbreviation: favouriteCompanies[index].abbreviation,
                logo: favouriteCompanies[index].logo ?? UIImage(named: "Kaspi")!,
                price: favouriteCompanies[index].price,
                isFavourite: favouriteCompanies[index].isFavourite
            )
            return companyToReturn
        }
    }
    
    func starButtonPressed(at index: Int, isFavourite: Bool) {
        if isFavourite == false {
            guard currentState == .stocks else { return }
            companies[index].isFavourite = true
            createFavouriteItem(company: companies[index])
        } else {
            switch currentState {
            case .stocks:
                let company = companies[index]
                if let favouriteIndex = favouriteCompanies.firstIndex(where: { $0.name == company.name }) {
                    companies[index].isFavourite = false
                    deleteItemFromFavourite(item: favouriteCompanies[favouriteIndex], index: favouriteIndex)
                }
                
            case .favourite:
                let company = favouriteCompanies[index]
                if let stockIndex = companies.firstIndex(where: { $0.name == company.name }) {
                    companies[stockIndex].isFavourite = false
                }
                deleteItemFromFavourite(item: favouriteCompanies[index], index: index)
            }
        }
        view?.reloadTableView()
    }
    func addCompany(_ companyToAdd: String) {
        manager.addNewCompany(companyName: companyToAdd){ company in
            if let stockIndex = self.companies.firstIndex(where: {$0.abbreviation == company.abbreviation}) {
                self.companies[stockIndex].price = company.price
                self.companies[stockIndex].logo = company.logo
            } else {
                self.createItem(company: company)
            }
            
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
    }
    
    private func createItem(company: Company) {
        let newCompany = CompanyItem(context: context)
        newCompany.name = company.name
        newCompany.abbreviation = company.abbreviation
        newCompany.logo = company.logo
        newCompany.isFavourite = company.isFavourite
        newCompany.price = company.price
        companies.append(newCompany)
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    private func createFavouriteItem(company: CompanyItem) {
        let newCompany = FavouriteCompanyItem(context: context)
        newCompany.name = company.name
        newCompany.abbreviation = company.abbreviation
        newCompany.logo = company.logo
        newCompany.isFavourite = company.isFavourite
        newCompany.price = company.price
        favouriteCompanies.append(newCompany)
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    private func deleteItemFromFavourite(item: FavouriteCompanyItem, index: Int) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("object does not deleted from coredata")
        }
        favouriteCompanies.remove(at: index)
    }
    
    private func deleteItemFromCompanies(item: CompanyItem, index: Int) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("object does not deleted from coredata")
        }
        companies.remove(at: index)
    }
    
    private func getAllCompanies() {
        do {
            companies = try context.fetch(CompanyItem.fetchRequest())
        } catch {
            print("Error in getAllItems, can not get items from database")
        }
    }
    private func getFavouriteCompanies() {
        do {
            favouriteCompanies = try context.fetch(FavouriteCompanyItem.fetchRequest())
        } catch {
            print("Error in getAllItems, can not get items from database")
        }
    }
    
    private func updateItem() {
        do {
            try context.save()
        } catch {
            print("object doesn't updated")
        }
    }
    
    func getPopularCompany(at index: Int) -> String {
        return popularRequestsCompanies[index]
    }
}


