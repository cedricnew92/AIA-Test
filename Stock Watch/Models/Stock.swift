//
//  Stock.swift
//  Stock Watch
//
//  Created by DERMALOG on 03/03/2021.
//

import Foundation

struct Stock: Codable {
    
    enum SortFormat: String {
        case open
        case high
        case low
        case date
    }
    
    init(
        intraDay: Array<(String, Float, Float, Float, Float, Float)>? = nil,
        dailyAdjusted: Array<(String, Float, Float, Float, Float, Float, Float, Float, Float)>? = nil
    ) {
        self.arrayIntraDay = intraDay
        self.arrayDailyAdjusted = dailyAdjusted
    }
    
    private var timeSeries1Min: [String: TimeSeries]?
    private var timeSeries5Min: [String: TimeSeries]?
    private var timeSeries15Min: [String: TimeSeries]?
    private var timeSeries30Min: [String: TimeSeries]?
    private var timeSeries60Min: [String: TimeSeries]?
    private var timeSeriesDaily: [String: TimeSeriesDaily]?
    
    var arrayIntraDay : Array<(String, Float, Float, Float, Float, Float)>?
    var arrayDailyAdjusted : Array<(String, Float, Float, Float, Float, Float, Float, Float, Float)>?
    
    mutating func convertDictToArray() {
        if (timeSeries1Min != nil) {
            self.arrayIntraDay = []
            for (key, value) in timeSeries1Min! {
                arrayIntraDay?.append((key, value.open, value.high, value.low, value.close, value.volume))
            }
        }
        if (timeSeries5Min != nil) {
            self.arrayIntraDay = []
            for (key, value) in timeSeries5Min! {
                arrayIntraDay?.append((key, value.open, value.high, value.low, value.close, value.volume))
            }
        }
        if (timeSeries15Min != nil) {
            self.arrayIntraDay = []
            for (key, value) in timeSeries15Min! {
                arrayIntraDay?.append((key, value.open, value.high, value.low, value.close, value.volume))
            }
        }
        if (timeSeries30Min != nil) {
            self.arrayIntraDay = []
            for (key, value) in timeSeries30Min! {
                arrayIntraDay?.append((key, value.open, value.high, value.low, value.close, value.volume))
            }
        }
        if (timeSeries60Min != nil) {
            self.arrayIntraDay = []
            for (key, value) in timeSeries60Min! {
                arrayIntraDay?.append((key, value.open, value.high, value.low, value.close, value.volume))
            }
        }
        if (timeSeriesDaily != nil) {
            self.arrayDailyAdjusted = []
            for (key, value) in timeSeriesDaily! {
                arrayDailyAdjusted?.append((key, value.open, value.high, value.low, value.close, value.adjustedClose, value.volume, value.dividend, value.coefficient))
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case timeSeries1Min = "Time Series (1min)"
        case timeSeries5Min = "Time Series (5min)"
        case timeSeries15Min = "Time Series (15min)"
        case timeSeries30Min = "Time Series (30min)"
        case timeSeries60Min = "Time Series (60min)"
        case timeSeriesDaily = "Time Series (Daily)"
    }
    
}

// MARK: - TimeSeries
struct TimeSeries: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var string = try container.decode(String.self, forKey: .open)
        let openFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let highFloat = Float(string)!
        string = try container.decode(String.self, forKey: .low)
        let lowFloat = Float(string)!
        string = try container.decode(String.self, forKey: .close)
        let closeFloat = Float(string)!
        string = try container.decode(String.self, forKey: .volume)
        let volumeFloat = Float(string)!
        self.init(open: openFloat, high: highFloat, low: lowFloat, close: closeFloat, volume: volumeFloat)
    }
    
    init(open: Float, high: Float, low: Float, close: Float, volume: Float) {
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
    
    let open, high, low, close, volume: Float

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

// MARK: - TimeSeriesDaily
struct TimeSeriesDaily: Codable {
    
    let open, high, low, close, adjustedClose, volume, dividend, coefficient: Float
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var string = try container.decode(String.self, forKey: .open)
        let openFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let highFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let lowFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let closeFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let adjustedCloseFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let volumeFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let dividendFloat = Float(string)!
        string = try container.decode(String.self, forKey: .high)
        let coefficientFloat = Float(string)!
        
        self.init(open: openFloat, high: highFloat, low: lowFloat, close: closeFloat, adjustedClose: adjustedCloseFloat, volume: volumeFloat, dividend: dividendFloat, coefficient: coefficientFloat)
    }
    
    init(open: Float, high: Float, low: Float, close: Float, adjustedClose: Float, volume: Float, dividend: Float, coefficient: Float) {
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.adjustedClose = adjustedClose
        self.volume = volume
        self.dividend = dividend
        self.coefficient = coefficient
    }

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
        case volume = "6. volume"
        case dividend = "7. dividend amount"
        case coefficient = "8. split coefficient"
    }
}
