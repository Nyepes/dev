//
//  City.swift
//  Favorite Cities
//
//  Created by Nicolas Yepes on 7/8/19.
//  Copyright © 2019 Nicolas Yepes. All rights reserved.
//

import UIKit

class City: Codable {

    var name:String
    var state:String
    var population:Int
    var flag:Data
    
    init (name: String, state: String, population:Int, flag:Data) {
        self.name = name
        self.state = state
        self.population = population
        self.flag = flag
    }
    
}
