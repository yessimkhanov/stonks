
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
    func starButtonPressed(for name: String)
    func addCompany(_ companyToAdd: String)
    func getPopularCompany(at index: Int) -> String
    func renewInfoOfCompanies()

    func makeChartsView(for index: Int, onDismiss: (() -> Void)?) -> ChartView
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
        renewInfoOfCompanies()
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
                    coreDataManager.deleteItemFromFavourite(
                        item: coreDataManager.favouriteCompanies[favIndex],
                        index: favIndex
                    )
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
    
    func starButtonPressed(for name: String) {
        coreDataManager.starButtonPressed(companyName: name)
        view?.reloadTableView()
    }
    
    func addCompany(_ companyToAdd: String) {
        networkingManager.addNewCompany(companyName: companyToAdd){ newCompany in
            if let stockIndex = self.coreDataManager.companies.firstIndex(where: {$0.abbreviation == newCompany.abbreviation}) {
                let company = self.coreDataManager.companies[stockIndex]
                if let favouriteCompaniesIndex = self.coreDataManager.favouriteCompanies.firstIndex(where: {$0.name == newCompany.name}) {
                    let favouriteCompany = self.coreDataManager.favouriteCompanies[favouriteCompaniesIndex]
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
        let length = coreDataManager.companies.count - 1
        return coreDataManager.companies[length - index].name
    }
    
    func makeChartsView(for index: Int, onDismiss: (() -> Void)? = nil) -> ChartView {
        let company: CompanyItem = {
            switch currentState {
            case .stocks:
                return coreDataManager.companies[index]
            case .favourite:
                let favoriteCompany = coreDataManager.favouriteCompanies[index]
                guard let companyIndex = coreDataManager.companies.firstIndex(where: {$0.name == favoriteCompany.name}) else {
                    return coreDataManager.companies[0]
                }
                return coreDataManager.companies[companyIndex]
            }
        }()
        
        let store: ChartsStore = ChartsStore(
            company: company,
            coreDataManager: coreDataManager,
            networkingManager: networkingManager
        )
        return ChartView(store: store, onDismiss: onDismiss)
    }
}


