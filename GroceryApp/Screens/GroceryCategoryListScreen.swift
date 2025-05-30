//
//  GroceryCategoryListScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 30.05.25.
//

import SwiftUI

struct GroceryCategoryListScreen: View {
    @Environment(GroceryViewModel.self) private var groceryVM
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresented: Bool = false

    private func fetchGroceryCategories() async {
        do {
            try await groceryVM.populateGroceryCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteGroceryCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            let groceryCategories = groceryVM.groceryCategories[index]
            
            Task {
                do {
                    try await groceryVM.deleteGroceryCategory(groceryCategoryId: groceryCategories.id)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(groceryVM.groceryCategories) { groceryCategory in
                HStack {
                    Circle()
                        .fill(Color.fromHex(groceryCategory.colorCode))
                        .frame(width: 24, height: 24)
                    Text(groceryCategory.title)
                }
            }.onDelete(perform: deleteGroceryCategory)
        }
        .task {
            await fetchGroceryCategories()
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Logout") {
                    
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresented = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }.sheet(isPresented: $isPresented) {
            NavigationStack {
                AddGroceryCategoryScreen()
            }
        }
    }
}

#Preview {
    NavigationStack {
        GroceryCategoryListScreen()
            .environment(GroceryViewModel())
    }
}
