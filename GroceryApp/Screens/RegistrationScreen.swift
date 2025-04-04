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
    @State private var confirmPassword: String = ""
    
    private var isValidPassword: Bool {
        password == confirmPassword
    }
    
    private var isValidForm: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 10)
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $username)
            SecureField("Password", text: $password)
            SecureField("Confirm Password", text: $confirmPassword)
            
            HStack {
                Button("Register") {
                    
                }
                .buttonStyle(.borderless)
            }
        }
        
    }
}

#Preview {
    RegistrationScreen()
}
