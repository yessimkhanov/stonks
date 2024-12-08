
import Foundation

final class StocksPresenter: PresenterProtocol {
    private weak var view: ViewProtocol?
    private var dataSource: CompanyDataSource
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
    
    func numberOfRows(for state: StateOfButton) -> Int {
        switch state {
        case .stocks:
            return dataSource.companies.count
        case .favourite:
            return dataSource.favouriteCompanies.count
        }
    }
    
    func companyForRow(at index: Int, for state: StateOfButton) -> Company {
        switch state {
        case .stocks:
            return dataSource.companies[index]
        case .favourite:
            return dataSource.favouriteCompanies[index]
        }
    }
    
    func heightForRow(at index: Int) -> CGFloat {
        return 68
    }
    
    func markFavourite(at index: Int, for state: StateOfButton) {
        guard state == .stocks else { return }
        dataSource.companies[index].isFavourite = true
        dataSource.favouriteCompanies.append(dataSource.companies[index])
        view?.reloadTableView()
    }
    
    func unmarkFavourite(at index: Int, for state: StateOfButton) {
        switch state {
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
        view?.reloadTableView()
    }
}
