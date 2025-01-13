//
//  ViewController.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func reloadTableView()
    func updateButtonStyles(for state: StateOfButton)
}

enum ScreenState {
    case mainScreen
    case searchScreen
}

final class ViewController:UIViewController {
    var stocksPresenter: StocksPresenterProtocol!
    var screenState: ScreenState = .mainScreen
    private lazy var stocksAppViews: StocksView = {
        let stocksAppViews = StocksView(frame: self.view.frame)
        stocksAppViews.tableView.delegate = self
        stocksAppViews.tableView.dataSource = self
        stocksAppViews.searchBar.delegate = self
        stocksAppViews.searchView.delegate = self
        stocksAppViews.stocksButton.addTarget(self, action: #selector(stocksButtonPressed), for: .touchUpInside)
        stocksAppViews.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        return stocksAppViews
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stocksAppViews)
        stocksPresenter.viewDidLoad()
        stocksAppViews.searchView.createButtons()
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
        return stocksPresenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company: Company = stocksPresenter.companyForRow(at: indexPath.row)
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
            indexPath: indexPath.row,
            change: company.change
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            self.stocksPresenter.deleteCompany(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                tableView.reloadData()
            }
        }
        return [deleteAction]
    }
}

extension ViewController:TickerCellDelegate {
    func starButtonPressed(at index: Int, for state: Bool) {
        stocksPresenter.starButtonPressed(at: index, isFavourite: state)
    }
}

extension ViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            switchViews()
            return true
        }
        //MARK: убери коммент что бы серч заново находил компании с бэка
        stocksPresenter.addCompany(text)
        stocksPresenter.renewInfoOfCompanies()
        switchViews()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switchViews()
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
        case .favourite:
            stocksAppViews.favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
            stocksAppViews.stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
            stocksAppViews.favouriteButton.setTitleColor(UIColor(rgb: 0x1A1A1A), for: .normal)
            stocksAppViews.stocksButton.setTitleColor(UIColor(rgb: 0xBABABA), for: .normal)
        }
    }
}

extension ViewController: StockViewDelegate {
    func returnToPreviousScreen() {
        switchViews()
    }
    
    func getPopularCompaniesName(at index: Int) -> String {
        let text = stocksPresenter.getPopularCompany(at: index)
        return text
    }
    
    func bubbleButtonPressed(name: String) {
        stocksPresenter.addCompany(name)
        switchViews()
        stocksAppViews.searchBar.resignFirstResponder()
    }
    
    func switchViews() {
        switch screenState {
        case .mainScreen:
            screenState = .searchScreen
            stocksAppViews.searchView.isHidden = false
            stocksAppViews.tableView.isHidden = true
            stocksAppViews.buttonStack.isHidden = true
        case .searchScreen:
            screenState = .mainScreen
            stocksAppViews.searchView.isHidden = true
            stocksAppViews.tableView.isHidden = false
            stocksAppViews.buttonStack.isHidden = false
            stocksAppViews.searchBar.resignFirstResponder()
        }
    }
}

