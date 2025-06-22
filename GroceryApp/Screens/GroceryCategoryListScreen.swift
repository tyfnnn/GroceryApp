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
    @Environment(AppState.self) private var appStateVM
    
    @State private var isPresented: Bool = false
    @State private var showError = false
    @State private var showLogoutAlert = false

    private func fetchGroceryCategories() async {
        do {
            try await groceryVM.populateGroceryCategories()
        } catch {
            showError = true
        }
    }
    
    private func deleteGroceryCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            let groceryCategories = groceryVM.groceryCategories[index]
            
            Task {
                do {
                    try await groceryVM.deleteGroceryCategory(groceryCategoryId: groceryCategories.id)
                } catch {
                    showError = true
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Group {
                if groceryVM.isLoading && groceryVM.groceryCategories.isEmpty {
                    // Loading state
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Kategorien werden geladen...")
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if groceryVM.groceryCategories.isEmpty && !groceryVM.isLoading {
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
                    .refreshable {
                        await fetchGroceryCategories()
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
                        showLogoutAlert = true
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    AddGroceryCategoryScreen()
                }
            }
            .disabled(groceryVM.isLoading)
            
            // Error Overlay
            if showError, let error = groceryVM.currentError {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showError = false
                            groceryVM.clearError()
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    if error.type == .authentication {
                        ErrorView.authenticationError(
                            message: error.message,
                            loginAction: {
                                withAnimation {
                                    showError = false
                                    groceryVM.clearError()
                                }
                                // Navigate to login
                                // appState.routes = [.login]
                            },
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    groceryVM.clearError()
                                }
                            }
                        )
                    } else {
                        ErrorView.networkError(
                            message: error.message,
                            retryAction: {
                                withAnimation {
                                    showError = false
                                    groceryVM.clearError()
                                }
                                Task {
                                    await fetchGroceryCategories()
                                }
                            },
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    groceryVM.clearError()
                                }
                            }
                        )
                    }
                    
                    Spacer()
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showError)
        .alert("Abmelden", isPresented: $showLogoutAlert) {
            Button("Abbrechen", role: .cancel) { }
            Button("Abmelden", role: .destructive) {
                groceryVM.logout()
                appStateVM.routes.removeAll()
            }
        } message: {
            Text("Möchten Sie sich wirklich abmelden?")
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
