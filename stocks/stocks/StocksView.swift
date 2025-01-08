//
//  File.swift
//  stocksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//
import Foundation
import UIKit

final class StocksView: UIView {
    //MARK: Main Screen's UI
    let searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.cornerRadius = 23
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        searchBar.textAlignment = .center
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Find Company or Ticker",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
        )
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
    
    //MARK: Popular Requests Screen's UI
    
    let popularRequestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Requests"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1A1A1A)
        label.isHidden = true
        return label
    }()
    
    let userSearchRequestsLabel: UILabel = {
        let label = UILabel()
        label.text = "You've searched for this"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1A1A1A)
        label.isHidden = true
        return label
    }()
    
    let popularRequestsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PopularRequestsCollectionViewCell.self, forCellWithReuseIdentifier: PopularRequestsCollectionViewCell.identifier)
        collectionView.isHidden = true
        return collectionView
    }()
    
    //MARK: Initialization
    private func addSubviews() {
        self.addSubview(searchBar)
        self.addSubview(tableView)
        buttonStack.addArrangedSubview(stocksButton)
        buttonStack.addArrangedSubview(favouriteButton)
        self.addSubview(buttonStack)
        self.addSubview(popularRequestsLabel)
        self.addSubview(popularRequestsCollectionView)
        self.addSubview(userSearchRequestsLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 48),
            
            buttonStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            buttonStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 128),
            buttonStack.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            popularRequestsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            popularRequestsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            popularRequestsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            userSearchRequestsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            userSearchRequestsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 183),
            userSearchRequestsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            popularRequestsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            popularRequestsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 67),
            popularRequestsCollectionView.bottomAnchor.constraint(
                equalTo: userSearchRequestsLabel.topAnchor,
                constant: -28
            ),
            popularRequestsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in initializing the StocksView")
    }
}

