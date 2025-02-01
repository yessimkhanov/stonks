//
//  StocksManager.swift
//  stocks
//
//  Created by Nursultan Turekulov on 17.12.2024.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case noSuchCompany
}

final class StocksManager {
    func addNewCompany(companyName: String, completion: @escaping(Company) -> Void){
        var newCompany = Company()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        searchCompany(companyName) { result in
            switch result {
            case .success(let company):
                    newCompany.abbreviation = company.displaySymbol
                    newCompany.name = company.description
                    
                    dispatchGroup.enter()
                    self.searchCompanyPrice(company.displaySymbol) { currentPrice, change in
                        newCompany.price = currentPrice
                        newCompany.change = change
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.enter()
                    self.searchCompanyLogo(company.displaySymbol) { image in
                        newCompany.logo = image
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.leave()
            case .failure(let error):
                print("Error in addNewCompany function")
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(newCompany)
        }
    }
    
    private func searchCompanyPrice(_ abbreviation: String, completion: @escaping(Double, String) -> Void) {
        let newURL = "https://finnhub.io/api/v1/quote?symbol=\(abbreviation)&token=ct6q70pr01qmbqosg59gct6q70pr01qmbqosg5a0"
        if let url = URL(string: newURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error  {
                    print(error)
                    print("Error in price function")
                    return
                }
                if let safeData = data {
                    if let data = self.parseJSONPrice(safeData){
                        let currentPrice = data.c
                        let priceChange = data.d
                        let priceChangePercentage = (data.dp * 100).rounded() / 100
                        let change: String = priceChangePercentage >= 0 ? "+$\(abs(priceChange)) (\(abs(priceChangePercentage))%)" : "-$\(abs(priceChange)) (\(abs(priceChangePercentage))%)"
                        completion(currentPrice, change)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func searchCompany(_ company: String, completion: @escaping(Result<Results, NetworkError>) -> Void){
        let newURL = "https://finnhub.io/api/v1/search?q=\(company)&exchange=US&token=ct6q70pr01qmbqosg59gct6q70pr01qmbqosg5a0"
        if let url = URL(string: newURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error  {
                    print(error)
                    print("Error in function called (searchCompany)")
                    return
                }
                if let safeData = data {
                    if let data = self.parseJSONCompany(safeData){
                        if !data.result.isEmpty {
                            completion(.success(data.result[0]))
                        } else {
                            print("No results found for company: \(company)")
                            completion(.failure(.noSuchCompany))
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func searchCompanyLogo(_ name: String, completion: @escaping(UIImage) -> Void){
        let defaultLogo = UIImage(named: "Kaspi")
        let newURL = "https://finnhub.io/api/logo?symbol=\(name)"
        if let url = URL(string: newURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {data, response, error in
                if let error = error  {
                    print(error)
                    print("Error in function called (searchCompanyLogo)")
                    completion(defaultLogo!)
                }
                if let safeData = data {
                    if let logo = UIImage(data: safeData){
                        completion(logo)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSONPrice(_ data:Data) -> CompanyPrice? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CompanyPrice.self, from: data)
            return decodedData
        } catch {
            print (error)
            return nil
        }
    }
    
    private func parseJSONCompany(_ data:Data) -> CompanyJSON? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CompanyJSON.self, from: data)
            return decodedData
        } catch {
            print (error)
            return nil
        }
    }
    
    //MARK: Networking layer for Graph
    func getGraphData(abbreviation: String, completion: @escaping (Result<GraphDaily, Error>) -> Void) {
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(abbreviation)&outputsize=full&apikey=CJQAJ8BN86EF9AKF"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error  {
                    print("Error in function called (searchCompany)")
                    completion(.failure(error))
                }
                if let safeData = data {
                    if let data = self.parseJSONGraph(safeData) {
                        completion(.success(data))
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSONGraph(_ data:Data) -> GraphDaily? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GraphDaily.self, from: data)
            return decodedData
        } catch {
            print (error)
            return nil
        }
    }
    
    private func parseJsonGraphHourly(_ data: Data) -> GraphHourly? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GraphHourly.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
    func getGraphDataDaily(abbreviation: String, completion: @escaping(Result<GraphHourly, Error>) -> Void) {
        let urlString =
        "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(abbreviation)&interval=60min&apikey=CJQAJ8BN86EF9AKF"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error  {
                    print("Error in function called (searchCompany)")
                    completion(.failure(error))
                }
                if let safeData = data {
                    if let data = self.parseJsonGraphHourly(safeData) {
                        completion(.success(data))
                    }
                }
            }
            task.resume()
        }
    }
    
}

