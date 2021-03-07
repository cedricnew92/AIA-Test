//
//  UIKitUtils.swift
//  Stock Watch
//
//  Created by DERMALOG on 04/03/2021.
//

import UIKit

class StorageUtils {
    
    static let KEY_OUTPUTSIZE = "output"
    static let KEY_INTERVAL = "interval"
    static let KEY_APIKEY = "apikey"
    
    static func set(key: String, value: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }

    static func get(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
