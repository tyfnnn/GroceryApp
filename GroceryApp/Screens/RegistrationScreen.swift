//
//  RegistrationScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import SwiftUI

struct RegistrationScreen: View {
    @Environment(GroceryViewModel.self) private var groceryModelVM
    @Environment(AppState.self) private var appStateVM
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError = false
    
    private func register() async {
        do {
            let registerResponseDTO = try await groceryModelVM.register(username: username, password: password)
            if !registerResponseDTO.error {
                appStateVM.routes.append(.login)
            } else {
                showError = true
            }
        } catch {
            showError = true
        }
    }
    
    private var isValidForm: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 10)
    }
    
    var body: some View {
        ZStack {
            Form {
                TextField("Email", text: $username)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                
                HStack {
                    Button("Register") {
                        Task {
                            await register()
                        }
                    }
                    .buttonStyle(.borderless)
                    .disabled(!isValidForm || groceryModelVM.isLoading)
                    
                    if groceryModelVM.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
            .navigationTitle("Registration")
            .disabled(groceryModelVM.isLoading)
            
            // Error Overlay
            if showError, let error = groceryModelVM.currentError {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showError = false
                            groceryModelVM.clearError()
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    if error.type == .validation {
                        ErrorView.validationError(
                            message: error.message,
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    groceryModelVM.clearError()
                                }
                            }
                        )
                    } else {
                        ErrorView.networkError(
                            message: error.message,
                            retryAction: {
                                withAnimation {
                                    showError = false
                                    groceryModelVM.clearError()
                                }
                                Task {
                                    await register()
                                }
                            },
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    groceryModelVM.clearError()
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
    }
}

struct RegistrationScreenContainer: View {
    @State private var appState = AppState()
    @State private var groceryModel = GroceryViewModel()
    
    var body: some View {
        NavigationStack(path: $appState.routes) {
            RegistrationScreen()
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
    }
}

#Preview {
    NavigationStack {
        RegistrationScreenContainer()
            .environment(AppState())
            .environment(GroceryViewModel())
    }
}
