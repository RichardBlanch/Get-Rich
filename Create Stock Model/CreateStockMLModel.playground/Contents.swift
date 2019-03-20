//: A Cocoa based Playground to present user interface

import CreateML
import Foundation

// Change richardblanchard to your path. This can be found by opening Terminal and typing 'cd ~/Desktop' and then typing 'pwd' and entering the response the Terminal returns.
let desktopDirectoryPath = "/Users/richardblanchard/Desktop/"

let trainingCSV = URL(fileURLWithPath: "\(desktopDirectoryPath)s-and-p-500-companies-financials_zip/data/constituents-financials_csv.csv")

do {
    
    let parsingOptions = MLDataTable.ParsingOptions(selectColumns: ["Price", "Price/Earnings", "52 Week Low", "52 Week High", "Market Cap", "Price/Book"])
    
    var stockData = try MLDataTable(contentsOf: trainingCSV, options: parsingOptions)
    stockData = stockData.fillMissing(columnNamed: "Price/Book", with: .int(0))
    stockData = stockData.fillMissing(columnNamed: "Price/Earnings", with: .int(0))

    let pricer = try MLRegressor(trainingData: stockData, targetColumn: "Price")
    try pricer.write(to: URL(fileURLWithPath: "\(desktopDirectoryPath)StockPricerMLModel.mlmodel"), metadata: MLModelMetadata(author: "Rich Blanchard", shortDescription: "A model which will take in information about a company's financial situation and return how much that company should be worth", license: nil, version: "0.1", additional: nil))
    
} catch {
    print("Error: \(error)")
}


