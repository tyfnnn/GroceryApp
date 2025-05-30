//
//  AddGroceryCategoryScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 30.05.25.
//

import SwiftUI

struct AddGroceryCategoryScreen: View {
    @State private var groceryVM: GroceryViewModel
    @State private var title: String = ""
    @State private var colorCode: String = "#2ecc71"
    
    @Environment(\.dismiss) private var dismiss
    
    private func saveGroceryCategory() async {
        
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            ColorSelector(colorCode: $colorCode)
        }.navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveGroceryCategory()
                        }
                    }.disabled(!isFormValid)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
    }
    
}

#Preview {
    NavigationStack {
        AddGroceryCategoryScreen(groceryVM: GroceryViewModel())
    }
}
