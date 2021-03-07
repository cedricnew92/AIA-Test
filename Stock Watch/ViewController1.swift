//
//  ViewController1.swift
//  Stock Watch
//
//  Created by DERMALOG on 03/03/2021.
//

import UIKit

class ViewController1 : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel = ViewModel1()
    private var stock = Stock()
    
    @IBOutlet weak var textFieldSymbol: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func actionSearch(_ sender: Any) {
        let symbol = textFieldSymbol.text
        if (symbol!.isEmpty) {
            showAlert(message: "Symbol cannot be empty")
            return
        }
        textFieldSymbol.resignFirstResponder()
        loading.startAnimating()
        loading.isHidden = false
        viewModel.fetchStockForSymbol(symbol!.uppercased())
    }
    
    @IBAction func actionSort(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Sort by", message: "Please select a sorting option", preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetController.addAction(cancelActionButton)

        let actionSortOpen = UIAlertAction(title: "Open", style: .default) { [self] _ in
            viewModel.sortStockBy(.open)
        }
        actionSheetController.addAction(actionSortOpen)
        
        let actionSortHigh = UIAlertAction(title: "High", style: .default) { [self] _ in
            viewModel.sortStockBy(.high)
        }
        actionSheetController.addAction(actionSortHigh)
        
        let actionSortLow = UIAlertAction(title: "Low", style: .default) { [self] _ in
            viewModel.sortStockBy(.low)
        }
        actionSheetController.addAction(actionSortLow)
        let actionSortDate = UIAlertAction(title: "Date", style: .default) { [self] _ in
            viewModel.sortStockBy(.date)
        }
        actionSheetController.addAction(actionSortDate)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        viewModel.stock.bind {[weak self] data in
            self!.loading.stopAnimating()
            self!.loading.isHidden = true
            if (data != nil && data!.arrayIntraDay == nil) {
                self!.showAlert(message: "No stock data found")
                return
            } else if (data == nil) {
                return
            }
            self?.stock = data!
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
        if (stock.arrayIntraDay == nil) {
            return 0
        }
        return stock.arrayIntraDay!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! Cell1
        let item = self.stock.arrayIntraDay![indexPath.row]
        
        cell.labelOpen.text = String(format:"%.2f", item.1)
        cell.labelHigh.text = String(format:"%.2f", item.2)
        cell.labelLow.text = String(format:"%.2f", item.3)
        let dateTime = item.0.components(separatedBy: " ")
        cell.labelDate.text = dateTime[0]
        cell.labelTime.text = dateTime[1]
        return cell
    }
    
}
