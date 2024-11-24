//
//  ViewController.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import UIKit

final class ViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("searching for smth")
    }
    
    //    func updateSearchResults(for searchController: UISearchController) {
    //
    //    }
    
    private var stocksAppViews : StocksView!
    private var dataSourceForTableView = CompanyDataSource()
    private var currentStateOfButtons = "Stocks"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stocksAppViews = StocksView(frame: self.view.frame)
        stocksAppViews.tableView.delegate = self
        stocksAppViews.tableView.dataSource = self
        view.addSubview(stocksAppViews)
        stocksAppViews.searchBar.delegate = self
        //        setUpSearchController()
        addTargets()
        // Do any additional setup after loading the view.
    }
    //    func setUpSearchController() {
    //        let searchController = stocksAppViews.searhController
    //        searchController.searchResultsUpdater = self
    //        searchController.obscuresBackgroundDuringPresentation = false
    //        searchController.searchBar.placeholder = "Search"
    //        searchController.hidesNavigationBarDuringPresentation = false
    //        navigationItem.searchController = searchController
    //        navigationItem.hidesSearchBarWhenScrolling = true
    //        self.definesPresentationContext = false
    //    }
    private func addTargets() {
        stocksAppViews.stocksButton.addTarget(self, action: #selector(stocksButtonPressed), for: .touchUpInside)
        stocksAppViews.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    @objc func stocksButtonPressed() {
        if currentStateOfButtons != "Stocks" {
            currentStateOfButtons = "Stocks"
            stocksAppViews.stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            stocksAppViews.stocksButton.setTitleColor(.black, for: .normal)
            stocksAppViews.favouriteButton.setTitleColor(.systemGray2, for: .normal)
            stocksAppViews.tableView.reloadData()
        }
    }
    @objc func favouriteButtonPressed() {
        if currentStateOfButtons != "Favourite" {
            currentStateOfButtons = "Favourite"
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            stocksAppViews.stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            stocksAppViews.favouriteButton.setTitleColor(.black, for: .normal)
            stocksAppViews.stocksButton.setTitleColor(.systemGray2, for: .normal)
            stocksAppViews.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentStateOfButtons == "Stocks" {
            return dataSourceForTableView.companies.count
        } else {
            return dataSourceForTableView.favouriteCompanies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentStateOfButtons == "Stocks" {
            let company = dataSourceForTableView.companies[indexPath.row]
            let cell = stocksAppViews.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            cell.delegate = self
            var backgroundColor : UIColor
            if (indexPath.row % 2 == 0){
                backgroundColor = UIColor.white
            } else {
                backgroundColor = UIColor.lightGray
            }
            cell.configure(logo: company.logo,
                           name: company.name,
                           abbrv: company.abbreviation,
                           price: company.price,
                           background: backgroundColor,
                           isFavourite: company.isFavourite,
                           indexPath: indexPath.row)
            return cell
        } else {
            let company = dataSourceForTableView.favouriteCompanies[indexPath.row]
            let cell = stocksAppViews.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            var backgroundColor : UIColor
            cell.delegate = self
            if (indexPath.row % 2 == 0){
                backgroundColor = UIColor.white
            } else {
                backgroundColor = UIColor.lightGray
            }
            cell.configure(logo: company.logo,
                           name: company.name,
                           abbrv: company.abbreviation,
                           price: company.price,
                           background: backgroundColor,
                           isFavourite: company.isFavourite,
                           indexPath: indexPath.row)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68 // Set the height dynamically
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ViewController: VCDelegate {
    func unMarkFavouriteCompany(at indexPath: Int) {
        if currentStateOfButtons == "Stocks" {
            let companyToRemove = dataSourceForTableView.companies[indexPath]
            if let favouriteIndex = dataSourceForTableView.favouriteCompanies.firstIndex(where: { $0.name == companyToRemove.name }) {
                dataSourceForTableView.companies[indexPath].isFavourite = false
                dataSourceForTableView.favouriteCompanies.remove(at: favouriteIndex)
            }
        } else {
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
