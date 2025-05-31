//
//  AppState.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 12.04.25.
//

import Foundation
import GroceryAppSharedDTO

enum Route: Hashable {
    case login
    case register
    case groceryCategoryList
    case groceryCategoryDetail(GroceryCategoryResponseDTO)
}

@Observable
class AppState {
    var routes: [Route] = []
}
