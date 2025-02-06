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
}

final class ChartsStore: ObservableObject {
    struct ViewState {
        struct Company {
            let abbreviation: String
            let change: String
            let price: Double
            let name: String
        }
        
        let data: [Double]
        let company: Company
        var isFavorite: Bool
        var selectedPeriod: String
        var selectedSubBar: String
    }
    @Published var viewState: ViewState?
    
    private let company: CompanyItem
    private let coreDataManager: CoreDataManager
    private let networkingManager: StocksManager
    
    init(
        company: CompanyItem,
        coreDataManager: CoreDataManager,
        networkingManager: StocksManager
    ) {
        self.company = company
        self.coreDataManager = coreDataManager
        self.networkingManager = networkingManager
        self.viewState = makeViewState()
        self.getDataForDayChart(abbreviation: company.abbreviation, period: 15)
    }
    
    private func makeViewState(
        data: [Double] = [],
        selectedPeriod: String = "D",
        selectedSubBar: String = "Chart"
    ) -> ViewState {
        let company: ViewState.Company = .init(
            abbreviation: company.abbreviation,
            change: company.change,
            price: company.price,
            name: company.name
        )
        return ViewState(
            data: data,
            company: company,
            isFavorite: self.company.isFavourite,
            selectedPeriod: viewState?.selectedPeriod ?? selectedPeriod,
            selectedSubBar: viewState?.selectedSubBar ?? selectedSubBar
        )
    }
    
    func periodButtonPressed(buttonTitle: String) {
        if let period = ChartPeriod(rawValue: buttonTitle) {
            switch period {
            case .day:
                getDataForDayChart(abbreviation: company.abbreviation, period: 15)
            case .week:
                getDataForChart(abbreviation: company.abbreviation, period: 7)
            case .month:
                getDataForChart(abbreviation: company.abbreviation, period: 31)
            case .halfYear:
                getDataForChart(abbreviation: company.abbreviation, period: 180)
            case .year:
                getDataForChart(abbreviation: company.abbreviation, period: 365)
            case .allTime:
                getDataForChart(abbreviation: company.abbreviation, period: 500)
            }
        }
        viewState?.selectedPeriod = buttonTitle
    }
    
    func buyButtonPressed() {
    }
    
    func favouriteButtonPressed() {
        if let viewState = viewState {
            coreDataManager.starButtonPressed(companyName: viewState.company.name)
        }
        viewState?.isFavorite.toggle()
    }
    
    func subBarButtonPressed(buttonTitle: String) {
        viewState?.selectedSubBar = buttonTitle
    }
    
    private func getDataForChart(abbreviation: String, period: Int) {
        var data: [Double] = []
        networkingManager.getGraphData(abbreviation: abbreviation) { result in
            switch result {
            case .success(let graphData):
                let sortedGraph = graphData.timeSeriesDaily.sorted(by: {$0.key > $1.key})
                for (_, dailyData) in sortedGraph.prefix(period).reversed() {
                    guard let closeDouble = Double(dailyData.close) else {continue}
                    data.append(closeDouble)
                }
                DispatchQueue.main.async {
                    self.viewState = self.makeViewState(data: data)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func getDataForDayChart(abbreviation: String, period: Int) {
        var data: [Double] = []
        networkingManager.getGraphDataDaily(abbreviation: abbreviation) { result in
            switch result {
            case .success(let graphData):
                let sortedGraph = graphData.timeSeriesIntraday.sorted(by: {$0.key > $1.key})
                for (_, dailyData) in sortedGraph.prefix(period).reversed() {
                    guard let closeDouble = Double(dailyData.close) else { continue }
                    data.append(closeDouble)
                }
                DispatchQueue.main.async {
                    self.viewState = self.makeViewState(data: data)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}
