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
    
    private func populateGroceryItems() async {
        do {
            try await groceryVM.populateGroceryItemsBy(groceryCategoryId: groceryCategory.id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            GroceryItemListView(groceryItems: groceryVM.groceryItems)
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
        .task {
            await populateGroceryItems()
        }
    }
}

#Preview {
    NavigationStack {
        GroceryDetailScreen(groceryCategory: GroceryCategoryResponseDTO(id: UUID(uuidString: "3fe323ea-86b0-429c-add9-8bdfa1816508")!, title: "Lebensmittel", colorCode: "#2ecc71"))
    }
    .environment(GroceryViewModel())
}
