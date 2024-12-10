//
//  Protocols.swift
//  stocks
//
//  Created by Nursultan Turekulov on 03.12.2024.
//

import Foundation

protocol TickerCellDelegate: AnyObject {
    func markFavouriteCompany(at index: Int)
    func unMarkFavouriteCompany(at index: Int)
}

protocol PresenterProtocol: AnyObject {
    var currentState: StateOfButton { get }
    func viewDidLoad()
    func stocksButtonPressed()
    func favouriteButtonPressed()
    func numberOfRows(for state: StateOfButton) -> Int
    func companyForRow(at index: Int, for state: StateOfButton) -> Company
    func markFavourite(at index: Int, for state: StateOfButton)
    func unmarkFavourite(at index: Int, for state: StateOfButton)
    func heightForRow(at index: Int) -> CGFloat
}

protocol ViewProtocol: AnyObject {
    func reloadTableView()
    func updateButtonStyles(for state: StateOfButton)
}
