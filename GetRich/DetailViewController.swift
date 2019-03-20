//
//  DetailViewController.swift
//  GetRich
//
//  Created by Richard Blanchard on 3/20/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import UIKit
import StockInformation

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let model = StockPricerMLModel()
    
    var name: Stock.Name? {
        didSet {
            guard let name = name else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.loadingContainerView.isHidden = false
            }
            
            DataProvider.shared.fetchFinancialInformation(for: name.symbol, success: { [weak self] stock in
                self?.stock = stock
                }, failure: { error in
                    fatalError()
            })
        }
    }
    
    private var stock: Stock? {
        didSet {
            guard isViewLoaded else { return }
            guard let stock = stock else { return }
            
            setUpUI(from: stock)
        }
    }

    // MARK: Outlets

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var predictedPrice: UILabel!
    @IBOutlet weak var loadingContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingContainerView.isHidden = true

        if let stock = stock {
            setUpUI(from: stock)
        }
    }
    
    private func setUpUI(from stock: Stock) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let name = self.name else { return }
            guard let predictedPrice = try? self.model.calculatePrice(from: stock) else { return }

            self.loadingContainerView.isHidden = true
            self.symbolLabel.text = name.company
            self.currentPriceLabel.text = "Current Price: " + String(stock.currentPrice)
            self.predictedPrice.text = "Predicted Price: " + String(predictedPrice.Price)
        }
    }
}
