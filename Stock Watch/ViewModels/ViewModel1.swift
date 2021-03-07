//
//  ViewModel1.swift
//  Stock Watch
//
//  Created by DERMALOG on 03/03/2021.
//

import Foundation

public class ViewModel1 {
    
    var stock : Box<Stock?> = Box(nil)
    
    func fetchStockForSymbol(_ symbol: String) {
        StockService.intraDayDataForSymbol(symbol: symbol) { [weak self] (data, error) in
            self?.stock.value = data
        }
    }
    
    func sortStockBy(_ type: Stock.SortFormat) {
        if (stock.value == nil) {
            return
        }
        let temp = stock.value!.arrayIntraDay!
        switch type {
        case .open :
            stock.value!.arrayIntraDay = temp.sorted {
                return $0.1 > $1.1
            }
        case .high:
            stock.value!.arrayIntraDay = temp.sorted {
                return $0.2 > $1.2
            }
        case .low:
            stock.value!.arrayIntraDay = temp.sorted {
                return $0.3 > $1.3
            }
        case .date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            stock.value!.arrayIntraDay = temp.sorted {
                let date0 = dateFormatter.date(from:$0.0)!
                let date1 = dateFormatter.date(from:$1.0)!
                return date0 > date1
            }
        }
    }
    
}
