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
                                
                Group {
                    if UserDefaults.standard.string(forKey: "authToken") == nil {
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
            .onChange(of: UserDefaults.standard.string(forKey: "authToken")) { oldValue, newValue in
                if newValue == nil {
                    appStateVM.routes.removeAll()
                }
            }
        }
    }
}
