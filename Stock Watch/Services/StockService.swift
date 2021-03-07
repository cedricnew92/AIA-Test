//
//  StockService.swift
//  Stock Watch
//
//  Created by DERMALOG on 03/03/2021.
//

import Foundation

enum StockError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class StockService {
    
    typealias StockDataCompletion = (Stock?, StockError?) -> ()
    
    private static var apiKey = "4A9J1OOPXBOUHE1H"
    private static let host = "www.alphavantage.co"
    private static let path = "/query"
    
    static func intraDayDataForSymbol(symbol: String, completion: @escaping StockDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        if let key = KeyChain.shared[StorageUtils.KEY_APIKEY] {
            apiKey = key
        }
        var interval = "5min"
        if let savedInterval = StorageUtils.get(key: StorageUtils.KEY_INTERVAL) {
            interval = savedInterval
        }
        var outputsize = "compact"
        if let savedOutputSize = StorageUtils.get(key: StorageUtils.KEY_OUTPUTSIZE) {
            outputsize = savedOutputSize
        }
        urlBuilder.queryItems = [
            URLQueryItem(name: "function", value: "TIME_SERIES_INTRADAY"),
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "interval", value: interval),
            URLQueryItem(name: "outputsize", value: outputsize),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        let url = urlBuilder.url!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from Alphavantage: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
              
                guard let data = data else {
                    print("No data returned from Alphavantage")
                    completion(nil, .noData)
                    return
                }
              
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process Alphavantage response")
                    completion(nil, .invalidResponse)
                    return
                }
              
                guard response.statusCode == 200 else {
                    print("Failure response from Alphavantage: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
              
                do {
                    //print(String(data: data, encoding: String.Encoding.utf8))
                    let decoder = JSONDecoder()
                    var stock: Stock = try decoder.decode(Stock.self, from: data)
                    stock.convertDictToArray()
                    completion(stock, nil)
                } catch {
                    print("Unable to decode Alphavantage response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
    static func dailyAdjustedDataForSymbol(symbol: String, completion: @escaping StockDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        if let key = KeyChain.shared[StorageUtils.KEY_APIKEY] {
            apiKey = key
        }
        var outputsize = "compact"
        if let savedOutputSize = StorageUtils.get(key: StorageUtils.KEY_OUTPUTSIZE) {
            outputsize = savedOutputSize
        }
        urlBuilder.queryItems = [
            URLQueryItem(name: "function", value: "TIME_SERIES_DAILY_ADJUSTED"),
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "outputsize", value: outputsize),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        let url = urlBuilder.url!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from Alphavantage: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
              
                guard let data = data else {
                    print("No data returned from Alphavantage")
                    completion(nil, .noData)
                    return
                }
              
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process Alphavantage response")
                    completion(nil, .invalidResponse)
                    return
                }
              
                guard response.statusCode == 200 else {
                    print("Failure response from Alphavantage: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
              
                do {
                    let decoder = JSONDecoder()
                    var stock: Stock = try decoder.decode(Stock.self, from: data)
                    stock.convertDictToArray()
                    completion(stock, nil)
                } catch {
                    print("Unable to decode Alphavantage response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
}
