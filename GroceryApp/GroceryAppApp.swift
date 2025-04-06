//
//  GroceryAppApp.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 31.03.25.
//

import SwiftUI

@main
struct GroceryAppApp: App {
    
    @State private var groceryModelVM = GroceryModel()
    
    var body: some Scene {
        WindowGroup {
            RegistrationScreen()
                .environment(groceryModelVM)
        }
    }
}
