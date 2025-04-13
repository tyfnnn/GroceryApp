//
//  AppState.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 12.04.25.
//

import Foundation

enum Route: Hashable {
    case login
    case register
    case groceryCategoryList
}

@Observable
class AppState {
    var routes: [Route] = []
}
