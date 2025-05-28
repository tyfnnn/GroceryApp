//
//  GroceryAppApp.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 31.03.25.
//

import SwiftUI

@main
struct GroceryAppApp: App {
    
    @State private var groceryVM = GroceryViewModel()
    @State private var appStateVM = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appStateVM.routes) {
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
            .environment(groceryVM)
            .environment(appStateVM)
        }
    }
}
