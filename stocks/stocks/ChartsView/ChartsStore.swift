//
//  SwiftUIView.swift
//  stocks
//
//  Created by Алдияр Есимханов on 23.01.2025.
//

import SwiftUI
import Foundation

enum ChartPeriod: String, CaseIterable {
    case day = "D"
    case week = "W"
    case month = "M"
    case halfYear = "6M"
    case year = "1Y"
    case allTime = "All"
    
    var data: [Double] {
        switch self {
        case .day:
            return [3, 1, 0.5, 15, -2, 3, 4, 7, 1]
        case .week:
            return [5, 2, 1, 10, -1, 2, 3, 6, 2]
        case .month:
            return [10, 5, 2, 20, -5, 8, 10, 15, 5]
        case .halfYear:
            return [15, 8, 4, 30, -8, 12, 18, 22, 8]
        case .year:
            return [20, 10, 5, 30, -10, 15, 20, 25, 10]
        case .allTime:
            return [50, 25, 12, 50, -20, 30, 45, 55, 20]
        }
    }
}

final class ChartsStore: ObservableObject {
    struct ChartState {
        let data: [Double]
    }
    @Published var chartState: ChartState?
    @Published var isFavourite: Bool = false
    @Published var selectedPeriod: String = "D"
    @Published var selectedSubBar: String = "Chart"
    var stocksPresenter: StocksPresenterProtocol!
    var company: Company
    var index: Int
    
    init(presenter: StocksPresenterProtocol, index: Int) {
        chartState = ChartState(
            data: [1, 2, 3, 4.5, 6, 15, 0, -2, 3, 6]
        )
        stocksPresenter = presenter
        self.index = index
        company = stocksPresenter.companyForRow(at: index)
        isFavourite = company.isFavourite
    }
    
    func periodButtonPressed(buttonTitle: String) {
        guard let period = ChartPeriod(rawValue: buttonTitle) else {return}
        chartState = ChartState(data: period.data)
        selectedPeriod = buttonTitle
    }
    
    func buyButtonPressed() {
    }
    
    func favouriteButtonPressed() {
        stocksPresenter.starButtonPressed(at: index, isFavourite: isFavourite)
        isFavourite.toggle()
    }
    
    func subBarButtonPressed(buttonTitle: String) {
        selectedSubBar = buttonTitle
    }
}
