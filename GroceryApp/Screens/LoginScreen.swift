//
//  LoginScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 11.04.25.
//

import SwiftUI

struct LoginScreen: View {
    @State var vm = GroceryModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    private var isValidCredentials: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    private func login() async {
        do {
            let loginResponseDTO = try await vm.login(username: username, password: password)
            
            if loginResponseDTO.error {
                errorMessage = loginResponseDTO.reason ?? "Unknown error"
            } else {
                // take the user to grocery categories list screen
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        NavigationStack {
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
                }
                
                Text(errorMessage)
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginScreen()
        .environment(GroceryModel())
}
