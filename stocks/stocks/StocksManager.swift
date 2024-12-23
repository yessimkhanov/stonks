//
//  StocksManager.swift
//  stocks
//
//  Created by Nursultan Turekulov on 17.12.2024.
//

import Foundation
class StocksManager {
    var url = "https://finnhub.io/api/v1/quote?symbol=&token=ct6q70pr01qmbqosg59gct6q70pr01qmbqosg5a0"
    weak var delegate: StocksPriceDelegate?
    func searchCompany(_ company: String) -> Double{
        let newURL = "https://finnhub.io/api/v1/quote?symbol=\(company)&token=ct6q70pr01qmbqosg59gct6q70pr01qmbqosg5a0"
        var price: Double?
        if let url = URL(string: newURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {data, response, error in
                if let error = error  {
                    print(error)
                }
                if let safeData = data {
                    if let data = self.parseJSONPrice(safeData){
//                        dispatchGroup.notify(queue: .main) {
//                            self.delegate?.changePriceOfCompany(data.c, company: company)
//                        }
                        price = data.c
                    }
                }
            }
            task.resume()
        }
        if let price = price {
            return price
        }else{
            print("BIIIIG ERRROOOOOR")
            return 0
        }
    }
    
    func searchCompanyName(_ company: String){
        let newURL = "https://finnhub.io/api/v1/search?q=\(company)&exchange=US&token=ct6q70pr01qmbqosg59gct6q70pr01qmbqosg5a0"
        var price: Double
        if let url = URL(string: newURL){
            let session = URLSession(configuration: .default)
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            price = searchCompany(company)
            let task = session.dataTask(with: url) {data, response, error in
                if let error = error  {
                    print(error)
                    dispatchGroup.leave()
                }
                if let safeData = data {
                    if let data = self.parseJSONCompany(safeData){
                        
                    }
                }
                dispatchGroup.leave()
            }
            task.resume()
        }
    }
    
    func parseJSONPrice(_ data:Data) -> CompanyPrice? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CompanyPrice.self, from: data)
            return decodedData
        } catch {
            print (error)
            return nil
        }
    }
    
    func parseJSONCompany(_ data:Data) -> Comp? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Comp.self, from: data)
            return decodedData
        } catch {
            print (error)
            return nil
        }
    }
}

protocol StocksPriceDelegate: AnyObject {
    func changePriceOfCompany(_ price: Double, company: String)
}
