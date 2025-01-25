//
//  SearchView.swift
//  stocks
//
//  Created by Алдияр Есимханов on 09.01.2025.
//

import Foundation
import UIKit

protocol StockViewDelegate: AnyObject {
    func getPopularCompaniesName(at index: Int) -> String
    func returnToPreviousScreen()
    func bubbleButtonPressed(name: String)
}

final class SearchView:UIView {
    weak var delegate: StockViewDelegate?
    let popularRequestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Requests"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1A1A1A)
        return label
    }()
    
    let userSearchRequestsLabel: UILabel = {
        let label = UILabel()
        label.text = "You've searched for this"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1A1A1A)
        return label
    }()
    
    let popularRequestsStackOne: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    let userRequestsStackOne: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    let userRequestsStackTwo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    let popularRequestsStackTwo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    lazy var returnButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        return button
    }()
    
    func createButtons() {
        for i in 0...5 {
            let popularCompanyButton: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
                button.layer.cornerRadius = 20
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(rgb: 0xF0F4F7)
                button.addTarget(self, action: #selector(bubbleButtonPressed(_:)), for: .touchUpInside)
                button.clipsToBounds = true
                return button
            }()
            
            let second: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
                button.layer.cornerRadius = 20
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(rgb: 0xF0F4F7)
                button.addTarget(self, action: #selector(bubbleButtonPressed(_:)), for: .touchUpInside)
                button.clipsToBounds = true
                return button
            }()
            
            let third: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
                button.layer.cornerRadius = 20
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(rgb: 0xF0F4F7)
                button.addTarget(self, action: #selector(bubbleButtonPressed(_:)), for: .touchUpInside)
                button.clipsToBounds = true
                return button
            }()
            
            let fourth: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
                button.layer.cornerRadius = 20
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(rgb: 0xF0F4F7)
                button.addTarget(self, action: #selector(bubbleButtonPressed(_:)), for: .touchUpInside)
                button.clipsToBounds = true
                return button
            }()
            
            if let text = delegate?.getPopularCompaniesName(at: i) {
                popularCompanyButton.setTitle(text, for: .normal)
                second.setTitle(text, for: .normal)
                third.setTitle(text, for: .normal)
                fourth.setTitle(text, for: .normal)
            }
        
            second.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            popularCompanyButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            third.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            fourth.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            popularRequestsStackOne.addArrangedSubview(popularCompanyButton)
            popularRequestsStackTwo.addArrangedSubview(second)
            userRequestsStackOne.addArrangedSubview(third)
            userRequestsStackTwo.addArrangedSubview(fourth)
        }
    }
    
    let scrollViewForPopularRequests: UIButtonScrollView = {
        let scrollView = UIButtonScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let scrollViewForPopularRequestsTwo: UIButtonScrollView = {
        let scrollView = UIButtonScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let scrollViewForUserRequests: UIButtonScrollView = {
        let scrollView = UIButtonScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let scrollViewForUserRequestsTwo: UIButtonScrollView = {
        let scrollView = UIButtonScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    func addSubviews() {
        self.addSubview(popularRequestsLabel)
        self.addSubview(userSearchRequestsLabel)
        scrollViewForPopularRequests.addSubview(popularRequestsStackOne)
        self.addSubview(scrollViewForPopularRequests)
        scrollViewForPopularRequestsTwo.addSubview(popularRequestsStackTwo)
        self.addSubview(scrollViewForPopularRequestsTwo)
        scrollViewForUserRequests.addSubview(userRequestsStackOne)
        self.addSubview(scrollViewForUserRequests)
        scrollViewForUserRequestsTwo.addSubview(userRequestsStackTwo)
        self.addSubview(scrollViewForUserRequestsTwo)
        self.addSubview(returnButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            popularRequestsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            popularRequestsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            popularRequestsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            userSearchRequestsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            userSearchRequestsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 183),
            userSearchRequestsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            scrollViewForPopularRequests.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollViewForPopularRequests.topAnchor.constraint(equalTo: self.topAnchor, constant: 67),
            scrollViewForPopularRequests.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewForPopularRequests.heightAnchor.constraint(equalToConstant: 88),
        
            popularRequestsStackOne.leadingAnchor.constraint(equalTo: scrollViewForPopularRequests.leadingAnchor),
            popularRequestsStackOne.trailingAnchor.constraint(equalTo: scrollViewForPopularRequests.trailingAnchor),
            popularRequestsStackOne.topAnchor.constraint(equalTo: scrollViewForPopularRequests.topAnchor),
            popularRequestsStackOne.bottomAnchor.constraint(equalTo: scrollViewForPopularRequests.bottomAnchor),
            popularRequestsStackOne.heightAnchor.constraint(equalToConstant: 40),
            
            scrollViewForPopularRequestsTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollViewForPopularRequestsTwo.topAnchor.constraint(equalTo: popularRequestsStackOne.bottomAnchor, constant: 8),
            scrollViewForPopularRequestsTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewForPopularRequestsTwo.heightAnchor.constraint(equalToConstant: 88),
        
            popularRequestsStackTwo.leadingAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.leadingAnchor),
            popularRequestsStackTwo.trailingAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.trailingAnchor),
            popularRequestsStackTwo.topAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.topAnchor),
            popularRequestsStackTwo.bottomAnchor.constraint(equalTo: scrollViewForPopularRequestsTwo.bottomAnchor),
            popularRequestsStackTwo.heightAnchor.constraint(equalToConstant: 40),
            
            scrollViewForUserRequests.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollViewForUserRequests.topAnchor.constraint(equalTo: self.topAnchor, constant: 218),
            scrollViewForUserRequests.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewForUserRequests.heightAnchor.constraint(equalToConstant: 88),
            
            userRequestsStackOne.leadingAnchor.constraint(equalTo: scrollViewForUserRequests.leadingAnchor),
            userRequestsStackOne.trailingAnchor.constraint(equalTo: scrollViewForUserRequests.trailingAnchor),
            userRequestsStackOne.topAnchor.constraint(equalTo: scrollViewForUserRequests.topAnchor),
            userRequestsStackOne.bottomAnchor.constraint(equalTo: scrollViewForUserRequests.bottomAnchor),
            userRequestsStackOne.heightAnchor.constraint(equalToConstant: 40),
            
            scrollViewForUserRequestsTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            scrollViewForUserRequestsTwo.topAnchor.constraint(equalTo: userRequestsStackOne.bottomAnchor, constant: 8),
            scrollViewForUserRequestsTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollViewForUserRequestsTwo.heightAnchor.constraint(equalToConstant: 88),
            
            userRequestsStackTwo.leadingAnchor.constraint(equalTo: scrollViewForUserRequestsTwo.leadingAnchor),
            userRequestsStackTwo.trailingAnchor.constraint(equalTo: scrollViewForUserRequestsTwo.trailingAnchor),
            userRequestsStackTwo.topAnchor.constraint(equalTo: scrollViewForUserRequestsTwo.topAnchor),
            userRequestsStackTwo.bottomAnchor.constraint(equalTo: scrollViewForUserRequestsTwo.bottomAnchor),
            userRequestsStackTwo.heightAnchor.constraint(equalToConstant: 40),
            
            returnButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            returnButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            returnButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            returnButton.topAnchor.constraint(equalTo: scrollViewForUserRequestsTwo.bottomAnchor, constant: 10),
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
    
    @objc private func returnButtonPressed() {
        self.delegate?.returnToPreviousScreen()
    }
    @objc private func bubbleButtonPressed(_ sender: UIButton) {
        guard let name = sender.titleLabel?.text else {return}
        self.delegate?.bubbleButtonPressed(name: name)
    }
}
