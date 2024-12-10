//
//  File.swift
//  stocksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//
import Foundation
import UIKit

final class StocksView: UIView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TickerCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    let stocksButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x1A1A1A), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(UIColor(rgb: 0xBABABA), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        return stack
    }()
    
    private func addSubviews() {
        self.addSubview(searchBar)
        self.addSubview(tableView)
        buttonStack.addArrangedSubview(stocksButton)
        buttonStack.addArrangedSubview(favouriteButton)
        self.addSubview(buttonStack)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            buttonStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            buttonStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 128),
            buttonStack.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in initializing the BMIView")
    }
}

