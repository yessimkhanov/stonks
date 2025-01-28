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
    struct ChartState {
        let data: [Double]
    }
    @Published var chartState: ChartState?
    @Published var isFavourite: Bool = false
    @Published var selectedPeriod: String = "D"
    @Published var selectedSubBar: String = "Chart"
    var coreDataManager: CoreDataManager
    var networkingManager: StocksManager
    var company: CompanyItem
    var index: Int
    var screenState: StateOfButton
    init(index: Int, coreData: CoreDataManager, screenState: StateOfButton, networkinManager: StocksManager) {
        self.index = index
        coreDataManager = coreData
        self.screenState = screenState
        self.networkingManager = networkinManager
        switch screenState {
        case .stocks:
            company = coreDataManager.companies[index]
        case .favourite:
            let favoriteCompany = coreDataManager.favouriteCompanies[index]
            guard let companyIndex = coreDataManager.companies.firstIndex(where: {$0.name == favoriteCompany.name}) else {
                company = coreData.companies[0]
                print("Error in finding company index in ChartStore file")
                return
            }
            company = coreDataManager.companies[companyIndex]
        }
        isFavourite = company.isFavourite
        self.getDataForDayChart(abbreviation: company.abbreviation, period: 15)
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
        selectedPeriod = buttonTitle
    }
    
    func buyButtonPressed() {
    }
    
    func favouriteButtonPressed() {
        if isFavourite {
            switch screenState {
            case .stocks:
                let company = coreDataManager.companies[index]
                if let favouriteIndex = coreDataManager.favouriteCompanies.firstIndex(where: {$0.name == company.name}) {
                    coreDataManager.companies[index].isFavourite = false
                    coreDataManager.deleteItemFromFavourite(
                        item:coreDataManager.favouriteCompanies[favouriteIndex],
                        index: favouriteIndex
                    )
                }
            case .favourite:
                let favouriteCompany = coreDataManager.favouriteCompanies[index]
                if let stockIndex = coreDataManager.companies.firstIndex(where: {$0.name == favouriteCompany.name}) {
                    coreDataManager.companies[stockIndex].isFavourite = false
                    coreDataManager.deleteItemFromFavourite(item: favouriteCompany, index: index)
                }
            }
        } else {
            guard screenState != .favourite else {return}
            let company = coreDataManager.companies[index]
            company.isFavourite = true
            coreDataManager.createFavouriteItem(company: company)
        }
        isFavourite.toggle()
    }
    
    func subBarButtonPressed(buttonTitle: String) {
        selectedSubBar = buttonTitle
    }
    
    func getDataForChart(abbreviation: String, period: Int) {
        var data: [Double] = []
        networkingManager.getGraphData(abbreviation: abbreviation) {result in
                switch result {
            case .success(let graphData):
                    let sortedGraph = graphData.timeSeriesDaily.sorted(by: {$0.key > $1.key})
                    for (date, dailyData) in sortedGraph.prefix(period).reversed() {
                        guard let closeDouble = Double(dailyData.close) else {continue}
                        data.append(closeDouble)
                        print("date:\(date) and price:\(closeDouble)")
                        
                    }
                    DispatchQueue.main.async {
                        self.chartState = ChartState(data: data)
                    }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getDataForDayChart(abbreviation: String, period: Int) {
        var data: [Double] = []
        networkingManager.getGraphDataDaily(abbreviation: abbreviation) { result in
            switch result {
            case .success(let graphData):
                let sortedGraph = graphData.timeSeriesIntraday.sorted(by: {$0.key > $1.key})
                for (date, dailyData) in sortedGraph.prefix(period).reversed() {
                    guard let closeDouble = Double(dailyData.close) else {continue}
                    data.append(closeDouble)
                }
                DispatchQueue.main.async {
                    self.chartState = ChartState(data: data)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}
