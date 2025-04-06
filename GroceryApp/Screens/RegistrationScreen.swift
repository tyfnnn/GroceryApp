//
//  RegistrationScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import SwiftUI

struct RegistrationScreen: View {
    @State private var groceryModelVM = GroceryModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State var errorMessage: String = ""
    
    private func register() async {
        
        do {
            let registerResponseDTO = try await groceryModelVM.register(username: username, password: password)
            if !registerResponseDTO.error {
                // take user to the login screen
            } else if let reason = registerResponseDTO.reason {
                // Display the error reason from the server
                errorMessage = reason
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private var isValidForm: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 10)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Email", text: $username)
                SecureField("Password", text: $password)
                
                HStack {
                    Button("Register") {
                        Task {
                            await register()
                        }
                    }
                    .buttonStyle(.borderless)
                    .disabled(!isValidForm)
                }
                
                Section {
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Registration")
        }
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
            .environment(GroceryModel())
    }
}
