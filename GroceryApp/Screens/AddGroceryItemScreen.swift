//
//  AddGroceryItemScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 31.05.25.
//

import SwiftUI
import GroceryAppSharedDTO

struct AddGroceryItemScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GroceryViewModel.self) private var groceryVM

    @State private var title: String = ""
    @State private var price: Double? = nil
    @State private var quantity: Int? = nil
    
    private var isFormValid: Bool {
        guard let price = price,
              let quantity = quantity else {
            return false
        }
        return !title.isEmptyOrWhitespace && price > 0 && quantity > 0
    }
    
    private func saveGroceryItem() async {
        guard let groceryCategory = groceryVM.groceryCategory,
              let price = price,
              let quantity = quantity
        else { return }
        
        let groceryItemRequestDTO = GroceryItemRequestDTO(title: title, price: price, quantity: quantity)
    }

    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Price", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
            TextField("Quantity", value: $quantity, format: .number)
        }.navigationTitle("New Grocery Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveGroceryItem()
                        }
                    }.disabled(!isFormValid)
                }
            }
    }
}

#Preview {
    NavigationStack {
        AddGroceryItemScreen()
    }
}
