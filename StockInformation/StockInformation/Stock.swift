//
//  Stock.swift
//  StockInformation
//
//  Created by Richard Blanchard on 3/20/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public struct Stock {
    init(keyInformation: KeyInformation, price: Price) {
        self.keyInformation = keyInformation
        self.price = price
    }
    
    let price: Price?
    let keyInformation: KeyInformation?
    var name: Name?
    
    public var currentPrice: Double {
        return self.price?.currentPriceDouble ?? 1.0
    }

    public var pricePerEarnings: Double {
        return currentPrice / (keyInformation?.fundamental.earningsPerShareDouble ?? 1.0)
    }

    public var pricePerBook: Double {
        return price?.currentPriceDouble ?? 0.0 / keyInformation!.fundamental.bookValue
    }
    
    public var fiftyTwoWeekHigh: Double {
        return keyInformation?.price.fiftyTwoWeekHighDouble ?? 0.0
    }
    
    public var fiftyTwoWeekLow: Double {
        return keyInformation?.price.fiftyTwoWeekHighLow ?? 0.0
    }
    
    public var marketCap: Double {
        return keyInformation?.fundamental.marketCapDouble ?? 0.0
    }
    
     public struct Name: Codable {
        public let symbol: String
        public let exchange: String
        public let company: String
        public let currency: String
        public let industry: String
        public let sector: String
        public let subindustry: String
    }
    
     struct Price: Codable {
        public let currentPrice: String

        public var currentPriceDouble: Double? {
            return Double(currentPrice) ?? 0.0
        }
        
        enum CodingKeys: String, CodingKey {
            case currentPrice = "Current Price"
        }
    }
    
    public struct KeyInformation: Codable {
        public let fundamental: Fundamental
        public let price: Price
        
        enum CodingKeys: String, CodingKey {
            case fundamental = "Fundamental"
            case price = "Price"
        }
        
        public struct Fundamental: Codable {
            let bookValuePerShare: String
            let earningsPerShare: String
            let marketCap: String
            
            var earningsPerShareDouble: Double {
                return Double(earningsPerShare) ?? 1.0
            }
            
            var bookValue: Double {
                return Double(bookValuePerShare) ?? 1.0
            }
            
            var marketCapDouble: Double? {
                return Double(marketCap)
            }
            
            enum CodingKeys: String, CodingKey {
                case bookValuePerShare = "Book Value per Share"
                case earningsPerShare = "EPS"
                case marketCap = "Market Cap ($M)"
            }
        }
        
        public struct Price: Codable {
            let fiftyTwoWeekHigh: String
            let fiftyTwoWeekLow: String
            
            var fiftyTwoWeekHighDouble: Double? {
                return Double(fiftyTwoWeekHigh)
            }
            
            var fiftyTwoWeekHighLow: Double? {
                return Double(fiftyTwoWeekLow)
            }
            
            
            
            enum CodingKeys: String, CodingKey {
                case fiftyTwoWeekHigh = "Price (52w High)"
                case fiftyTwoWeekLow = "Price (52w Low)"
            }
        }
    }
}
