//
//  ViewController.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import UIKit

final class ViewController:UIViewController {
    var dataSourceForTableView = CompanyDataSource()
    
    private lazy var stocksPresenter: PresenterProtocol = {
        return StocksPresenter(view: self, dataSource: dataSourceForTableView)
    }()
    
    private lazy var stocksAppViews: StocksView = {
        let stocksAppViews = StocksView(frame: self.view.frame)
        stocksAppViews.tableView.delegate = self
        stocksAppViews.tableView.dataSource = self
        stocksAppViews.searchBar.delegate = self
        return stocksAppViews
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stocksAppViews)
        addTargets()
        stocksPresenter.viewDidLoad()
    }
    
    private func addTargets() {
        stocksAppViews.stocksButton.addTarget(self, action: #selector(stocksButtonPressed), for: .touchUpInside)
        stocksAppViews.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func stocksButtonPressed(_ sender: UIButton) {
        stocksPresenter.stocksButtonPressed()
    }
    
    @objc
    private func favouriteButtonPressed() {
        stocksPresenter.favouriteButtonPressed()
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksPresenter.numberOfRows(for: stocksPresenter.currentState)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company: Company = stocksPresenter.companyForRow(at: indexPath.row, for: stocksPresenter.currentState)
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
        return stocksPresenter.heightForRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ViewController:TickerCellDelegate {
    func unMarkFavouriteCompany(at index: Int) {
        stocksPresenter.unmarkFavourite(at: index, for: stocksPresenter.currentState)
    }
    
    func markFavouriteCompany(at index: Int) {
        stocksPresenter.markFavourite(at: index, for: stocksPresenter.currentState)
    }
}

extension ViewController:UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("searching for something")
    }
}

extension ViewController:ViewProtocol {
    func reloadTableView() {
        stocksAppViews.tableView.reloadData()
    }
    
    func updateButtonStyles(for state: StateOfButton) {
        switch state{
        case .stocks:
            stocksAppViews.stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
            stocksAppViews.stocksButton.setTitleColor(UIColor(rgb: 0x1A1A1A), for: .normal)
            stocksAppViews.favouriteButton.setTitleColor(UIColor(rgb: 0xBABABA), for: .normal)
            stocksAppViews.tableView.reloadData()
        case .favourite:
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
            stocksAppViews.stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
            stocksAppViews.favouriteButton.setTitleColor(UIColor(rgb: 0x1A1A1A), for: .normal)
            stocksAppViews.stocksButton.setTitleColor(UIColor(rgb: 0xBABABA), for: .normal)
        }
    }
}
