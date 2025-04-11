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
    
    private var isValidCredentials: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    private func login() async {
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                
                HStack {
                    Button("Login") {
                        
                    }
                    .buttonStyle(.borderless)
                    .disabled(!isValidCredentials)
                }
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginScreen()
        .environment(GroceryModel())
}
