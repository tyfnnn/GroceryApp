//
//  Constants.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 05.04.25.
//

import Foundation

struct Constants {
    private static let baseUrlPath = "http://127.0.0.1:8000/api"
    
    struct Urls {
        static let register = URL(string: "\(baseUrlPath)/register")!
    }
}
