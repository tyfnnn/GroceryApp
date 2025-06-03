//
//  LoginScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 11.04.25.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(GroceryViewModel.self) private var vm
    @Environment(AppState.self) private var appState
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError = false
    
    private var isValidCredentials: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 10)
    }
    
    private func login() async {
        do {
            let loginResponseDTO = try await vm.login(username: username, password: password)
            
            if loginResponseDTO.error {
                showError = true
            } else {
                appState.routes.append(.groceryCategoryList)
            }
        } catch {
            showError = true
        }
    }

    var body: some View {
        ZStack {
            Form {
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                
                HStack {
                    Button("Login") {
                        Task {
                            await login()
                        }
                    }
                    .buttonStyle(.borderless)
                    .disabled(!isValidCredentials || vm.isLoading)
                    
                    if vm.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
            .navigationTitle("Login")
            .disabled(vm.isLoading)
            
            // Error Overlay
            if showError, let error = vm.currentError {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showError = false
                            vm.clearError()
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
                                    vm.clearError()
                                }
                            },
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    vm.clearError()
                                }
                            }
                        )
                    } else if error.type == .validation {
                        ErrorView.validationError(
                            message: error.message,
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    vm.clearError()
                                }
                            }
                        )
                    } else {
                        ErrorView.networkError(
                            message: error.message,
                            retryAction: {
                                withAnimation {
                                    showError = false
                                    vm.clearError()
                                }
                                Task {
                                    await login()
                                }
                            },
                            dismissAction: {
                                withAnimation {
                                    showError = false
                                    vm.clearError()
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

#Preview {
    LoginScreen()
        .environment(GroceryViewModel())
        .environment(AppState())
}
