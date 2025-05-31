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
        Group {
            if groceryVM.groceryCategories.isEmpty {
                // Empty state view
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("Keine Kategorien vorhanden")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Fügen Sie Ihre erste Kategorie hinzu, um zu beginnen")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        isPresented = true
                    } label: {
                        Label("Kategorie hinzufügen", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                // List with categories
                List {
                    ForEach(groceryVM.groceryCategories) { groceryCategory in
                        NavigationLink(value: Route.groceryCategoryDetail(groceryCategory)) {
                            HStack {
                                Circle()
                                    .fill(Color.fromHex(groceryCategory.colorCode))
                                    .frame(width: 24, height: 24)
                                Text(groceryCategory.title)
                            }
                        }
                    }.onDelete(perform: deleteGroceryCategory)
                }
            }
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

struct GroceryCategoryListScreenContainer: View {
    @State private var appState = AppState()
    @State private var groceryModel = GroceryViewModel()
    
    var body: some View {
        NavigationStack(path: $appState.routes) {
            GroceryCategoryListScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .register:
                        RegistrationScreen()
                    case .login:
                        LoginScreen()
                    case .groceryCategoryList:
                        Text("Grocery Category List")
                    case .groceryCategoryDetail(let groceryCategory):
                        GroceryDetailScreen(groceryCategory: groceryCategory)
                    }
                    
                }
        }
        .environment(groceryModel)
        .environment(appState)
    }
}

#Preview {
    GroceryCategoryListScreenContainer()
}
