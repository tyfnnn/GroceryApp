//
//  RegistrationScreen.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import SwiftUI

struct RegistrationScreen: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    private func register() async {
        
    }
    
    private var isValidForm: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 10)
    }
    
    var body: some View {
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
        }
        
    }
}

#Preview {
    RegistrationScreen()
}
