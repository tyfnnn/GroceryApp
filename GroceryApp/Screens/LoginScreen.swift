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
    @State private var errorMessage: String = ""
    
    private var isValidCredentials: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 10)
    }
    
    private func login() async {
        do {
            let loginResponseDTO = try await vm.login(username: username, password: password)
            
            if loginResponseDTO.error {
                errorMessage = loginResponseDTO.reason ?? "Unknown error"
            } else {
                // take the user to grocery categories list screen
                appState.routes.append(.groceryCategoryList)
            }
        } catch {
            errorMessage = error.localizedDescription
            appState.errorWrapper = ErrorWrapper(error: error, guidance: error.localizedDescription)
        }
    }

    
    var body: some View {
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
                .disabled(!isValidCredentials)
                Spacer()
                Button("Register") {
                    Task {
                        appState.routes.append(.register)
                    }
                }
                .buttonStyle(.borderless)
            }
            
            Text(errorMessage)
        }
        .navigationTitle("Login")
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    LoginScreen()
        .environment(GroceryViewModel())
        .environment(AppState())
}
