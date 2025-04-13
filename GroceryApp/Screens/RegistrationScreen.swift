//
//  RegistrationScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import SwiftUI

struct RegistrationScreen: View {
    @Environment(GroceryModel.self) private var groceryModelVM
    @Environment(AppState.self) private var appStateVM
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State var errorMessage: String = ""
    
    private func register() async {
        
        do {
            let registerResponseDTO = try await groceryModelVM.register(username: username, password: password)
            if !registerResponseDTO.error {
                // take user to the login screen
                appStateVM.routes.append(.login)
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
                .disabled(!isValidForm)
            }
            Text(errorMessage)
        }
        .navigationTitle("Registration")
    }
}

struct RegistrationScreenContainer: View {
    @State private var appState = AppState()
    @State private var groceryModel = GroceryModel()
    
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
                    }
                }
        }
    }
}

#Preview {
    RegistrationScreenContainer()
        .environment(AppState())
        .environment(GroceryModel())
}
