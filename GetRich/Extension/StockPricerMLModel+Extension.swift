//
//  StockPricerMLModel+Extension.swift
//  GetRich
//
//  Created by Richard Blanchard on 3/20/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation
import StockInformation

extension StockPricerMLModel {
    func calculatePrice(from stock: Stock) throws -> StockPricerMLModelOutput {
        let stockPricerOutput = try prediction(Price_Earnings: stock.pricePerEarnings, _52_Week_Low: stock.fiftyTwoWeekLow, _52_Week_High: stock.fiftyTwoWeekHigh, Market_Cap: stock.marketCap, Price_Book: stock.pricePerBook)
        
        return stockPricerOutput
    }
}
