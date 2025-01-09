//
//  File.swift
//  stocksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//
import Foundation
import UIKit

protocol StockViewDelegate: AnyObject {
    func getPopularCompaniesName(at index: Int) -> String
}

final class StocksView: UIView {
    //MARK: Main Screen's UI
    weak var delegate: StockViewDelegate?
    let popularRequestsCompanies: [String] = ["Apple", "Amazon", "Google", "Visa", "American Airlines LLC.", "Garmin LTD"]
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
    
    let popularRequestsStackOne: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    func createButtons() {
        for i in 0...5 {
            let popularCompanyButton: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 12)
                button.layer.cornerRadius = 15
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(rgb: 0xF0F4F7)
                button.clipsToBounds = true
                return button
            }()
            
            let second: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 12)
                button.layer.cornerRadius = 15
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(rgb: 0xF0F4F7)
                button.clipsToBounds = true
                return button
            }()
            
            if let text = delegate?.getPopularCompaniesName(at: i) {
                popularCompanyButton.setTitle(text, for: .normal)
                second.setTitle(text, for: .normal)
            }
        
            second.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            popularCompanyButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            popularRequestsStackOne.addArrangedSubview(popularCompanyButton)
            popularRequestsStackTwo.addArrangedSubview(second)
        }
    }
    
    let popularRequestsStackTwo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    
    let scrollViewForPopularRequests: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isHidden = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let scrollViewForPopularRequestsTwo: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isHidden = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: Initialization
    private func addSubviews() {
        self.addSubview(searchBar)
        self.addSubview(tableView)
        buttonStack.addArrangedSubview(stocksButton)
        buttonStack.addArrangedSubview(favouriteButton)
        self.addSubview(buttonStack)
        self.addSubview(popularRequestsLabel)
        self.addSubview(userSearchRequestsLabel)
        scrollViewForPopularRequests.addSubview(popularRequestsStackOne)
        self.addSubview(scrollViewForPopularRequests)
        scrollViewForPopularRequestsTwo.addSubview(popularRequestsStackTwo)
        self.addSubview(scrollViewForPopularRequestsTwo)
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
            
            scrollViewForPopularRequests.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollViewForPopularRequests.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 67),
            scrollViewForPopularRequests.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewForPopularRequests.heightAnchor.constraint(equalToConstant: 50),
        
            popularRequestsStackOne.leadingAnchor.constraint(equalTo: scrollViewForPopularRequests.leadingAnchor),
            popularRequestsStackOne.trailingAnchor.constraint(equalTo: scrollViewForPopularRequests.trailingAnchor),
            popularRequestsStackOne.topAnchor.constraint(equalTo: scrollViewForPopularRequests.topAnchor),
            popularRequestsStackOne.bottomAnchor.constraint(equalTo: scrollViewForPopularRequests.bottomAnchor),
            popularRequestsStackOne.heightAnchor.constraint(equalToConstant: 40),
            
            scrollViewForPopularRequestsTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollViewForPopularRequestsTwo.topAnchor.constraint(equalTo: scrollViewForPopularRequests.bottomAnchor, constant: 8),
            scrollViewForPopularRequestsTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewForPopularRequestsTwo.heightAnchor.constraint(equalToConstant: 50),
        
            popularRequestsStackTwo.leadingAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.leadingAnchor),
            popularRequestsStackTwo.trailingAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.trailingAnchor),
            popularRequestsStackTwo.topAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.topAnchor),
            popularRequestsStackTwo.bottomAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.bottomAnchor),
            popularRequestsStackTwo.heightAnchor.constraint(equalToConstant: 40),

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

