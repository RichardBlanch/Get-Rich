//
//  StockTableViewController.swift
//  GetRich
//
//  Created by Richard Blanchard on 3/20/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import UIKit
import StockInformation

class StockTableViewController: UITableViewController {
    
    private enum Segue: String {
        case goToDetail
    }
    
    var stockNames: [Stock.Name] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private var error: Error? {
        didSet {
            guard let error = error else { return }

            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: "ERROR!", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataProvider.shared.fetchStockNames({ stockNames in
            self.stockNames = stockNames
        }, failure: { error in
            self.error = error
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = stockNames[indexPath.row].company
        
        return tableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Segue.goToDetail.rawValue, let indexPath = sender as? IndexPath {
            let name = stockNames[indexPath.row]
            ((segue.destination as? UINavigationController)?.topViewController as? DetailViewController)?.name = name
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.goToDetail.rawValue, sender: indexPath)
    }
}
