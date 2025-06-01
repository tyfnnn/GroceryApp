//
//  GroceryItemListView.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 01.06.25.
//

import SwiftUI
import GroceryAppSharedDTO

struct GroceryItemListView: View {
    let groceryItems: [GroceryItemResponseDTO]
    
    var body: some View {
        List {
            ForEach(groceryItems) { groceryItem in
                Text(groceryItem.title)
            }
        }
    }
}

#Preview {
    GroceryItemListView(groceryItems: [])
}
