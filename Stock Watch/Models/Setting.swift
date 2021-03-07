//
//  Setting.swift
//  Stock Watch
//
//  Created by DERMALOG on 05/03/2021.
//

import Foundation

class Setting {

    enum SettingType: String {
        case header
        case item
    }
    
    let type : SettingType
    var title, description: String
    
    init(title: String) {
        self.type = .header
        self.title = title
        self.description = ""
    }
    
    init(title: String, description: String) {
        self.type = .item
        self.title = title
        self.description = description
    }
    
}
