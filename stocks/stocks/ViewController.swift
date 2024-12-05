//
//  ViewController.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import UIKit

final class ViewController: UIViewController{
    
    private var dataSourceForTableView = CompanyDataSource()
    private enum StateOfButton {
        case stocks
        case favourite
    }
    private var currentState = StateOfButton.stocks
    private lazy var stocksAppViews: StocksView = {
        stocksAppViews = StocksView(frame: self.view.frame)
        stocksAppViews.tableView.delegate = self
        stocksAppViews.tableView.dataSource = self
        stocksAppViews.searchBar.delegate = self
        return stocksAppViews
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stocksAppViews)
        addTargets()
    }
    
    private func addTargets() {
        stocksAppViews.stocksButton.addTarget(self, action: #selector(stocksButtonPressed), for: .touchUpInside)
        stocksAppViews.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func stocksButtonPressed(_ sender: UIButton) {
        switch currentState {
        case .favourite:
            currentState = .stocks
            stocksAppViews.stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
            stocksAppViews.stocksButton.setTitleColor(UIColor(rgb: 0x1A1A1A), for: .normal)
            stocksAppViews.favouriteButton.setTitleColor(UIColor(rgb: 0xBABABA), for: .normal)
            stocksAppViews.tableView.reloadData()
        default:
            break
        }
    }
    
    @objc
    private func favouriteButtonPressed() {
        switch currentState{
        case .stocks:
            currentState = .favourite
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
            stocksAppViews.stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
            stocksAppViews.favouriteButton.setTitleColor(UIColor(rgb: 0x1A1A1A), for: .normal)
            stocksAppViews.stocksButton.setTitleColor(UIColor(rgb: 0xBABABA), for: .normal)
            stocksAppViews.tableView.reloadData()
        default:
            break
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .stocks:
            return dataSourceForTableView.companies.count
        case .favourite:
            return dataSourceForTableView.favouriteCompanies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company: Company
        switch currentState{
        case .stocks:
            company = dataSourceForTableView.companies[indexPath.row]
        case .favourite:
            company = dataSourceForTableView.favouriteCompanies[indexPath.row]
        }
        
        let cell = stocksAppViews.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TickerCell
        cell.delegate = self
        let backgroundColor: UIColor = indexPath.row % 2 == 0 ? UIColor(rgb: 0xFFFFFF) : UIColor(rgb: 0xF0F4F7)
        cell.configure(
            logo: company.logo,
            name: company.name,
            abbreviature: company.abbreviation,
            price: company.price,
            background: backgroundColor,
            isFavourite: company.isFavourite,
            indexPath: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ViewController: TickerCellDelegate {
    func unMarkFavouriteCompany(at indexPath: Int) {
        switch currentState {
        case .stocks:
            let companyToRemove = dataSourceForTableView.companies[indexPath]
            if let favouriteIndex = dataSourceForTableView.favouriteCompanies.firstIndex(where: { $0.name == companyToRemove.name }) {
                dataSourceForTableView.companies[indexPath].isFavourite = false
                dataSourceForTableView.favouriteCompanies.remove(at: favouriteIndex)
            }
        case .favourite:
            let companyToRemove = dataSourceForTableView.favouriteCompanies[indexPath]
            if let stockIndex = dataSourceForTableView.companies.firstIndex(where: { $0.name == companyToRemove.name }) {
                dataSourceForTableView.companies[stockIndex].isFavourite = false
            }
            dataSourceForTableView.favouriteCompanies.remove(at: indexPath)
        }
        stocksAppViews.tableView.reloadData()
    }
    
    func markFavouriteCompany(at indexPath: Int) {
        dataSourceForTableView.companies[indexPath].isFavourite = true
        dataSourceForTableView.favouriteCompanies.append(dataSourceForTableView.companies[indexPath])
        stocksAppViews.tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("searching for something")
    }
}


