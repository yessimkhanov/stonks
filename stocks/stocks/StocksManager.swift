//
//  StocksManager.swift
//  stocks
//
//  Created by Nursultan Turekulov on 17.12.2024.
//

import Foundation
import UIKit

protocol StocksNetworkingDelegate: AnyObject {
    func addNewCompany(_ price: Double, _ abbreviation: String, _ name: String, _ logo: UIImage)
}

final class StocksManager {
    weak var delegate: StocksNetworkingDelegate?
    
    private var price: Double?
    private var logo: UIImage?
    private var abbreviation: String?
    private var name: String?
    private let dispatchGroup = DispatchGroup()
    
    func addNewCompany(companyName: String){
        dispatchGroup.enter()
        searchCompany(companyName) { company in
            self.abbreviation = company.displaySymbol
            self.name = company.description
            
            self.dispatchGroup.enter()
            self.searchCompanyPrice(company.displaySymbol) { price in
                self.price = price
                self.dispatchGroup.leave()
            }
            
            self.dispatchGroup.enter()
            self.searchCompanyLogo(company.displaySymbol) { logo in
                self.logo = logo
                self.dispatchGroup.leave()
            }
            
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            guard let name = self.name,
                  let abbreviation = self.abbreviation,
                  let logo = self.logo,
                  let price = self.price else {
                print("Error in dispatchgroup")
                return
            }
            self.delegate?.addNewCompany(price, abbreviation, name, logo)
        }
    }
    
    private func searchCompanyPrice(_ abbreviation: String, completion: @escaping(Double) -> Void) {
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
                        completion(data.c)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func searchCompany(_ company: String, completion: @escaping(Results) -> Void){
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
                        completion(data.result[0])
                    }
                }
            }
            task.resume()
        }
    }
    
    private func searchCompanyLogo(_ name: String, completion: @escaping(UIImage) -> Void){
        let newURL = "https://finnhub.io/api/logo?symbol=\(name)"
        if let url = URL(string: newURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {data, response, error in
                if let error = error  {
                    print(error)
                    print("Error in function called (searchCompanyLogo)")
                    return
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
}

