//
//  AuthenticationScreen.swift
//  GroceryApp
//
//  Created by Assistant on 22.06.25.
//

import SwiftUI

struct AuthenticationScreen: View {
    @Environment(GroceryViewModel.self) private var vm
    @Environment(AppState.self) private var appState
    
    @State private var isLoginMode = true
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var isAnimating = false
    
    private var isValidForm: Bool {
        !username.isEmptyOrWhitespace &&
        !password.isEmptyOrWhitespace &&
        password.count >= 6 &&
        password.count <= 10
    }
    
    private func authenticate() async {
        do {
            if isLoginMode {
                let response = try await vm.login(username: username, password: password)
                if !response.error {
                    withAnimation(.easeInOut) {
                        appState.routes.append(.groceryCategoryList)
                    }
                } else {
                    showError = true
                }
            } else {
                let response = try await vm.register(username: username, password: password)
                if !response.error {
                    // Switch to login mode after successful registration
                    withAnimation(.spring()) {
                        isLoginMode = true
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isAnimating = false
                    }
                } else {
                    showError = true
                }
            }
        } catch {
            showError = true
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.15),
                    Color.purple.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Logo and title section
                VStack(spacing: 20) {
                    Image(systemName: "cart.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Text("Grocery App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .primary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Mode switcher
                HStack(spacing: 0) {
                    Button {
                        withAnimation(.spring()) {
                            isLoginMode = true
                        }
                    } label: {
                        Text("Anmelden")
                            .fontWeight(isLoginMode ? .semibold : .regular)
                            .foregroundColor(isLoginMode ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                isLoginMode ? AnyView(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .blue.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                ) : AnyView(Color.clear)
                            )
                    }
                    
                    Button {
                        withAnimation(.spring()) {
                            isLoginMode = false
                        }
                    } label: {
                        Text("Registrieren")
                            .fontWeight(!isLoginMode ? .semibold : .regular)
                            .foregroundColor(!isLoginMode ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                !isLoginMode ? AnyView(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple, .purple.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                ) : AnyView(Color.clear)
                            )
                    }
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                // Form fields
                VStack(spacing: 16) {
                    // Username field
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("Benutzername", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
                    
                    // Password field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        SecureField("Passwort", text: $password)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
                    
                    // Password requirements hint
                    if !isLoginMode || (password.count > 0 && (password.count < 6 || password.count > 10)) {
                        Text("Passwort muss 6-10 Zeichen lang sein")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Action button
                Button {
                    Task {
                        await authenticate()
                    }
                } label: {
                    HStack {
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.9)
                        } else {
                            Text(isLoginMode ? "Anmelden" : "Registrieren")
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: isLoginMode ? [.blue, .blue.opacity(0.8)] : [.purple, .purple.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(isValidForm && !vm.isLoading ? 1 : 0.6)
                    )
                    .shadow(
                        color: (isLoginMode ? Color.blue : Color.purple).opacity(0.3),
                        radius: isValidForm ? 10 : 0,
                        x: 0,
                        y: isValidForm ? 5 : 0
                    )
                }
                .disabled(!isValidForm || vm.isLoading)
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                
                
            }
            
            // Error overlay
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
                    
                    Group {
                        if error.type == .validation {
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
                                        await authenticate()
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
                    }
                    .transition(.opacity.combined(with: .scale))
                    
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showError)
        .animation(.spring(), value: isLoginMode)
    }
}

#Preview {
    AuthenticationScreen()
        .environment(GroceryViewModel())
        .environment(AppState())
}
