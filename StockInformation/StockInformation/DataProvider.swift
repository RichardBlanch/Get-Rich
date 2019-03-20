//
//  DataProvider.swift
//  StockInformation
//
//  Created by Richard Blanchard on 3/20/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public class DataProvider {
    public static let shared = DataProvider()

    public func fetchStockNames(_ success: @escaping (([Stock.Name]) -> Void), failure: @escaping ((Error?) -> Void)) {
        let urlString = "https://api.gurufocus.com/public/user/\(API.GuruFocus.key)/exchange_stocks/NYSE"
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { failure(nil); return }
            
            do {
                let stockNames = try JSONDecoder().decode([Stock.Name].self, from: data)
                success(stockNames)
            } catch {
                failure(error)
            }
        }
        
        task.resume()
    }
    
    public func fetchFinancialInformation(for symbol: String, success: @escaping (Stock) -> Void, failure: @escaping (Error?) -> Void) {
        fetchStockPrice(with: symbol, success: { price in
            self.fetchStockInformation(with: symbol, completion: { keyInformation in
                guard let keyInformation = keyInformation else { failure(nil); return }

                success(Stock(keyInformation: keyInformation, price: price))
            })
        }, failure: failure)
    }
    
    
    func fetchStockPrice(with symbol: String, success: @escaping (Stock.Price) -> Void, failure: @escaping ((Error?) -> Void)) {
        let urlString = "https://api.gurufocus.com/public/user/\(API.GuruFocus.key)/stock/\(symbol)/quote"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard let data = data else { failure(nil); return }
            
            do {
                 let stockPrice = try JSONDecoder().decode(Stock.Price.self, from: data)
                 success(stockPrice)
            } catch {
                 failure(error)
            }
        }
        
        task.resume()
    }
    
    private func fetchStockInformation(with symbol: String, completion: @escaping (Stock.KeyInformation?) -> Void) {
        let urlString = "https://api.gurufocus.com/public/user/3da57fd4d973db2dc9ab6179f8a1faef:0f53717ff582f81cf4f4f64dbabbbfd6/stock/\(symbol)/keyratios"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard let data = data else { fatalError() }
            
            do {
                let keyInformation = try JSONDecoder().decode(Stock.KeyInformation.self, from: data)
                completion(keyInformation)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
