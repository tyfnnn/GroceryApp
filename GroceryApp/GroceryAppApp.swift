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
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "authToken")
        
        WindowGroup {
            NavigationStack(path: $appStateVM.routes) {
                                
                Group {
                    if token == nil {
                        AuthenticationScreen()
                    } else {
                        GroceryCategoryListScreen()
                    }
                }
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .register:
                            AuthenticationScreen()
                        case .login:
                            AuthenticationScreen()
                        case .groceryCategoryList:
                            GroceryCategoryListScreen()
                        case .groceryCategoryDetail(let groceryCategory):
                            GroceryDetailScreen(groceryCategory: groceryCategory)
                        }
                    }
            }
            .environment(groceryVM)
            .environment(appStateVM)
        }
    }
}
