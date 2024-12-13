
import Foundation

protocol StocksPresenterProtocol: AnyObject {
    var currentState: StateOfButton { get }
    func viewDidLoad()
    func stocksButtonPressed()
    func favouriteButtonPressed()
    func numberOfRows() -> Int
    func companyForRow(at index: Int) -> Company
    func starButtonPressed(at index: Int, isFavourite: Bool)
}

final class StocksPresenter: StocksPresenterProtocol {
    
    private weak var view: ViewProtocol?
    private var dataSource = CompanyDataSource()
    var currentState: StateOfButton = .stocks
    
    init(view: ViewProtocol, dataSource: CompanyDataSource) {
        self.view = view
        self.dataSource = dataSource
    }
    
    func viewDidLoad() {
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
            return dataSource.companies.count
        case .favourite:
            return dataSource.favouriteCompanies.count
        }
    }
    
    func companyForRow(at index: Int) -> Company {
        switch currentState {
        case .stocks:
            return dataSource.companies[index]
        case .favourite:
            return dataSource.favouriteCompanies[index]
        }
    }
    
    func starButtonPressed(at index: Int, isFavourite: Bool) {
        if isFavourite == false {
            guard currentState == .stocks else { return }
            dataSource.companies[index].isFavourite = true
            dataSource.favouriteCompanies.append(dataSource.companies[index])
        }else{
            switch currentState {
            case .stocks:
                let company = dataSource.companies[index]
                if let favouriteIndex = dataSource.favouriteCompanies.firstIndex(where: { $0.name == company.name }) {
                    dataSource.favouriteCompanies.remove(at: favouriteIndex)
                    dataSource.companies[index].isFavourite = false
                }
            case .favourite:
                let company = dataSource.favouriteCompanies[index]
                if let stockIndex = dataSource.companies.firstIndex(where: { $0.name == company.name }) {
                    dataSource.companies[stockIndex].isFavourite = false
                }
                dataSource.favouriteCompanies.remove(at: index)
            }
        }
        view?.reloadTableView()
    }
}

enum StateOfButton {
    case stocks
    case favourite
}
