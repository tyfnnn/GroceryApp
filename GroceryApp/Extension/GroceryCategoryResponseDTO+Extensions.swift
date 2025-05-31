//
//  GroceryCategoryResponseDTO+Extensions.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 30.05.25.
//

import Foundation
import GroceryAppSharedDTO

extension GroceryCategoryResponseDTO: @retroactive Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: GroceryCategoryResponseDTO, rhs: GroceryCategoryResponseDTO) -> Bool {
        return lhs.id == rhs.id
    }
    
}
