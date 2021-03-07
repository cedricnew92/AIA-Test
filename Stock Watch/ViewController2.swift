//
//  ViewController2.swift
//  Stock Watch
//
//  Created by DERMALOG on 05/03/2021.
//

import UIKit

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel = ViewModel2()
    private var compare : Array<Stock> = []
    
    @IBOutlet weak var textFieldSymbol: UITextField!
    @IBOutlet weak var stackViewSymbols: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func actionClear(_ sender: Any) {
        compare = []
        stackViewSymbols.subviews.forEach({ $0.removeFromSuperview() })
        tableView.reloadData()
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let symbol = textFieldSymbol.text
        if (symbol!.isEmpty) {
            showAlert(message: "Symbol cannot be empty")
            return
        }
        if (compare.count == 3) {
            showAlert(message: "You're only allowed to compare up to 3 symbols")
            return
        }
        textFieldSymbol.endEditing(true)
        loading.startAnimating()
        loading.isHidden = false
        viewModel.fetchStockForSymbol(symbol!.uppercased())
    }
    
    override func viewDidLoad() {
        viewModel.stock.bind {[weak self] data in
            self!.loading.stopAnimating()
            self!.loading.isHidden = true
            if (data != nil && data!.arrayDailyAdjusted == nil) {
                self!.showAlert(message: "No stock data found")
                return
            } else if (data == nil) {
                return
            }
            let label = UILabel()
            label.textAlignment = .center
            label.text = self!.textFieldSymbol.text
            self!.stackViewSymbols.addArrangedSubview(label)
            self?.compare.append(data!)
            self!.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (compare.isEmpty) {
            return 0
        }
        return compare[0].arrayDailyAdjusted!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! Cell2
        
        cell.stackViewOpen.subviews.forEach({ $0.removeFromSuperview() })
        cell.stackViewLow.subviews.forEach({ $0.removeFromSuperview() })
        for stock in compare {
            let item = stock.arrayDailyAdjusted![indexPath.row]
            cell.labelDateTime.text = item.0
            let labelOpen = UILabel()
            labelOpen.textAlignment = .center
            labelOpen.text = String(format:"%.2f", item.1)
            cell.stackViewOpen.addArrangedSubview(labelOpen)
            let labelLow = UILabel()
            labelLow.textAlignment = .center
            labelLow.text = String(format:"%.2f", item.3)
            cell.stackViewLow.addArrangedSubview(labelLow)
        }
        
        return cell
    }
    
}
