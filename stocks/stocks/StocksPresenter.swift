
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
    func renewInfoOfCompanies()
}

final class StocksPresenter: StocksPresenterProtocol {
    let popularRequestsCompanies: [String] = ["Apple", "Amazon", "Google", "Visa", "American Airlines LLC.", "Garmin LTD"]
    let companies: [String] = ["Apple", "Amazon", "American Airlines", "Garmin LTD", "Microsoft", "Twitter", "Nike", "Adidas", "PepsiCo", "Coca-Cola", "Procter & Gamble", "Johnson & Johnson", "ABT", "ADBE", "Nasdaq", "NYSE"]
    private weak var view: ViewProtocol?
    private var dataSource: CompanyDataSource
    var currentState: StateOfButton = .stocks
    private var networkingManager: StocksManager
    var coreDataManager: CoreDataManager
    init(view: ViewProtocol, dataSource: CompanyDataSource, networkingManager: StocksManager, coreDataManager: CoreDataManager) {
        self.view = view
        self.dataSource = dataSource
        self.networkingManager = networkingManager
        self.coreDataManager = coreDataManager
    }
    
    func viewDidLoad() {
        coreDataManager.getAllCompanies()
        coreDataManager.getFavouriteCompanies()
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
    
    func renewInfoOfCompanies() {
        let dispatchGroup = DispatchGroup()
        for company in coreDataManager.companies {
            dispatchGroup.enter()
            addCompany(company.name)
            print("Company refreshed: \(company.name)")
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            print("All companies added")
        }
    }
    
    func numberOfRows() -> Int {
        switch currentState {
        case .stocks:
            return coreDataManager.companies.count
        case .favourite:
            return coreDataManager.favouriteCompanies.count
        }
    }
    
    func deleteCompany(index: Int) {
        switch currentState {
        case .stocks:
            if coreDataManager.companies[index].isFavourite {
                if let favIndex = coreDataManager.favouriteCompanies.firstIndex(where: { $0.name == coreDataManager.companies[index].name }) {
                    coreDataManager.deleteItemFromFavourite(item: coreDataManager.favouriteCompanies[favIndex], index: favIndex)
                }
            }
            coreDataManager.deleteItemFromCompanies(item: coreDataManager.companies[index], index: index)
            
        case .favourite:
            let favouriteItem = coreDataManager.favouriteCompanies[index]
            if let compIndex = coreDataManager.companies.firstIndex(where: { $0.name == favouriteItem.name }) {
                coreDataManager.deleteItemFromCompanies(item: coreDataManager.companies[compIndex], index: compIndex)
            }
            coreDataManager.deleteItemFromFavourite(item: favouriteItem, index: index)
        }
    }
    
    
    func companyForRow(at index: Int) -> Company {
        switch currentState {
        case .stocks:
            let companyToReturn = Company(
                name: coreDataManager.companies[index].name,
                abbreviation: coreDataManager.companies[index].abbreviation,
                logo: coreDataManager.companies[index].logo ?? UIImage(named: "Kaspi")!,
                price: coreDataManager.companies[index].price,
                isFavourite: coreDataManager.companies[index].isFavourite,
                change: coreDataManager.companies[index].change
            )
            return companyToReturn
        case .favourite:
            let companyToReturn = Company(
                name: coreDataManager.favouriteCompanies[index].name,
                abbreviation: coreDataManager.favouriteCompanies[index].abbreviation,
                logo: coreDataManager.favouriteCompanies[index].logo ?? UIImage(named: "Kaspi")!,
                price: coreDataManager.favouriteCompanies[index].price,
                isFavourite: coreDataManager.favouriteCompanies[index].isFavourite,
                change: coreDataManager.favouriteCompanies[index].change
            )
            return companyToReturn
        }
    }
    
    func starButtonPressed(at index: Int, isFavourite: Bool) {
        if isFavourite == false {
            guard currentState == .stocks else { return }
            coreDataManager.companies[index].isFavourite = true
            coreDataManager.createFavouriteItem(company: coreDataManager.companies[index])
        } else {
            switch currentState {
            case .stocks:
                let company = coreDataManager.companies[index]
                if let favouriteIndex = coreDataManager.favouriteCompanies.firstIndex(where: { $0.name == company.name }) {
                    coreDataManager.companies[index].isFavourite = false
                    coreDataManager.deleteItemFromFavourite(item: coreDataManager.favouriteCompanies[favouriteIndex], index: favouriteIndex)
                }
                
            case .favourite:
                let company = coreDataManager.favouriteCompanies[index]
                if let stockIndex = coreDataManager.companies.firstIndex(where: { $0.name == company.name }) {
                    coreDataManager.companies[stockIndex].isFavourite = false
                }
                coreDataManager.deleteItemFromFavourite(item: coreDataManager.favouriteCompanies[index], index: index)
            }
        }
        view?.reloadTableView()
    }
    func addCompany(_ companyToAdd: String) {
        networkingManager.addNewCompany(companyName: companyToAdd){ company in
            if let stockIndex = self.coreDataManager.companies.firstIndex(where: {$0.abbreviation == company.abbreviation}) {
                if let favouriteCompaniesIndex = self.coreDataManager.favouriteCompanies.firstIndex(where: {$0.name == company.name}) {
                    self.coreDataManager.favouriteCompanies[favouriteCompaniesIndex].price = company.price
                    self.coreDataManager.favouriteCompanies[favouriteCompaniesIndex].logo = company.logo
                    self.coreDataManager.favouriteCompanies[favouriteCompaniesIndex].change = company.change
                }
                self.coreDataManager.companies[stockIndex].price = company.price
                self.coreDataManager.companies[stockIndex].logo = company.logo
                self.coreDataManager.companies[stockIndex].change = company.change
            } else {
                self.coreDataManager.createItem(company: company)
            }
            
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
    }
    
    func getPopularCompany(at index: Int) -> String {
        return coreDataManager.companies[index].name
    }
}


