//
//  Protocols.swift
//  stocks
//
//  Created by Nursultan Turekulov on 03.12.2024.
//

import Foundation

protocol TickerCellDelegate: AnyObject {
    func markFavouriteCompany(at indexPath: Int)
    func unMarkFavouriteCompany(at indexPath: Int)
}
