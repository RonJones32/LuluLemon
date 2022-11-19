//
//  item.swift
//  LuluLemon
//
//  Created by Ronald Jones on 11/19/22.
//

import Foundation

class item {
    var name: String?
    var dateCreated: Date?
    
    convenience init (title: String, date: Date) {
        self.init()
        self.name = title
        self.dateCreated = date
    }
}
