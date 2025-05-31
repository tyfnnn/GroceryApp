//
//  GroceryDetailScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 31.05.25.
//

import SwiftUI
import GroceryAppSharedDTO

struct GroceryDetailScreen: View {
    @Environment(GroceryViewModel.self) private var groceryVM

    let groceryCategory: GroceryCategoryResponseDTO
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            List(1...10, id: \.self) { index in
                Text("Grocery Item \(index)")
            }
        }.navigationTitle(groceryCategory.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Grocery Item") {
                    isPresented = true
                }
            }
        }.sheet(isPresented: $isPresented) {
            NavigationStack {
                AddGroceryItemScreen()
            }
        }
        .onAppear {
            groceryVM.groceryCategory = groceryCategory
        }
    }
}

#Preview {
    NavigationStack {
        GroceryDetailScreen(groceryCategory: GroceryCategoryResponseDTO(id: UUID(), title: "Lebensmittel", colorCode: "#2ecc71"))
    }
    .environment(GroceryViewModel())
}
