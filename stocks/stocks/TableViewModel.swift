//
//  TableViewModel.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import Foundation
import UIKit
// MARK: HardCoded Companies
struct Company {
    var name: String
    var abbreviation: String
    var logo: UIImage
    var price: Double
    var isFavourite: Bool
}
struct CompanyDataSource {
    var companies: [Company] = [
        Company(name: "Yandex, LLC",abbreviation: "YNDX", logo: UIImage(named: "Yandex")!, price: 72.16, isFavourite: false),
        Company(name: "Apple, Inc.",abbreviation: "AAPL", logo: UIImage(named: "Apple")!, price: 131.93, isFavourite: false),
        Company(name: "Alphabet Class A", abbreviation: "GOOGL", logo: UIImage(named: "Google")!, price: 1825, isFavourite: false),
        Company(name: "Amazon.com", abbreviation: "AMZN", logo: UIImage(named: "Amazon")!, price: 3204, isFavourite: false),
    ]
    var favouriteCompanies: [Company] = []
}
// MARK: Companies from the internet
struct CompanyPrice: Decodable {
    let c: Double
}

struct CompanyJSON: Decodable {
    let count: Int
    let result: [Results]
}
struct Results: Decodable {
    let displaySymbol: String
    let description: String
}
