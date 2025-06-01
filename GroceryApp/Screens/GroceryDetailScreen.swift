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
    
    private func deleteGroceryItem(groceryItemId: UUID) {
        Task {
            do {
                try await groceryVM.deleteGroceryItem(groceryCategoryId: groceryCategory.id, groceryItemId: groceryItemId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            Group {
                if groceryVM.groceryItems.isEmpty {
                    // Empty state view
                    VStack(spacing: 16) {
                        Image(systemName: "cart.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("Keine Artikel vorhanden")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("Fügen Sie Ihren ersten Artikel zu \"\(groceryCategory.title)\" hinzu")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button {
                            isPresented = true
                        } label: {
                            Label("Artikel hinzufügen", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    // List with grocery items
                    GroceryItemListView(groceryItems: groceryVM.groceryItems, onDelete: deleteGroceryItem)
                }
            }
        }
        .navigationTitle(groceryCategory.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Grocery Item") {
                    isPresented = true
                }
            }
        }
        .sheet(isPresented: $isPresented) {
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
