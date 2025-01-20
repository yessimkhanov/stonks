
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
    
    private weak var view: ViewProtocol?
    private let dataSource: CompanyDataSource
    var currentState: StateOfButton = .stocks
    private let networkingManager: StocksManager
    private let coreDataManager: CoreDataManager
    
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
        for company in coreDataManager.companies {
            addCompany(company.name)
            print("Company refreshed: \(company.name)")
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
        networkingManager.addNewCompany(companyName: companyToAdd){ newCompany in
            if let stockIndex = self.coreDataManager.companies.firstIndex(where: {$0.abbreviation == newCompany.abbreviation}) {
                var company = self.coreDataManager.companies[stockIndex]
                if let favouriteCompaniesIndex = self.coreDataManager.favouriteCompanies.firstIndex(where: {$0.name == newCompany.name}) {
                    var favouriteCompany = self.coreDataManager.favouriteCompanies[favouriteCompaniesIndex]
                    favouriteCompany.price = newCompany.price
                    favouriteCompany.logo = newCompany.logo
                    favouriteCompany.change = newCompany.change
                }
                company.price = newCompany.price
                company.logo = newCompany.logo
                company.change = newCompany.change
            } else {
                self.coreDataManager.createItem(company: newCompany)
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


