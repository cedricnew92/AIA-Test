//
//  ViewModel2.swift
//  Stock Watch
//
//  Created by DERMALOG on 05/03/2021.
//

import Foundation

class ViewModel2 {
    
    var stock : Box<Stock?> = Box(nil)
    
    func fetchStockForSymbol(_ symbol: String) {
        StockService.dailyAdjustedDataForSymbol(symbol: symbol) { [weak self] (data, error) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let sorted = data?.arrayDailyAdjusted?.sorted {
                let date0 = dateFormatter.date(from:$0.0)!
                let date1 = dateFormatter.date(from:$1.0)!
                return date0 > date1
            }
            var data1 = data
            data1?.arrayDailyAdjusted = sorted
            self?.stock.value = data1
        }
    }
    
}
