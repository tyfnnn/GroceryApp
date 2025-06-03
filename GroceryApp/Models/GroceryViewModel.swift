//
//  GroceryModel.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 05.04.25.
//

import Foundation
import Observation
import GroceryAppSharedDTO

// MARK: - Error State Management
struct AppError: Error, Equatable {
    let title: String
    let message: String
    let type: ErrorType
    
    enum ErrorType {
        case network
        case server
        case validation
        case authentication
        case general
    }
    
    static func networkError(message: String = "Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.") -> AppError {
        AppError(title: "Verbindungsfehler", message: message, type: .network)
    }
    
    static func serverError(message: String = "Der Server ist momentan nicht erreichbar. Bitte versuchen Sie es später erneut.") -> AppError {
        AppError(title: "Server Fehler", message: message, type: .server)
    }
    
    static func validationError(message: String) -> AppError {
        AppError(title: "Eingabefehler", message: message, type: .validation)
    }
    
    static func authenticationError(message: String = "Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.") -> AppError {
        AppError(title: "Anmeldung erforderlich", message: message, type: .authentication)
    }
}

@Observable
class GroceryViewModel {
    
    var groceryCategories: [GroceryCategoryResponseDTO] = []
    var groceryItems: [GroceryItemResponseDTO] = []
    var groceryCategory: GroceryCategoryResponseDTO?
    
    // Error handling
    var currentError: AppError?
    var isLoading = false
    
    let httpClient = HTTPClient()
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .badRequest:
                currentError = .validationError(message: "Ungültige Anfrage. Überprüfen Sie Ihre Eingaben.")
            case .serverError(let message):
                currentError = .serverError(message: message)
            case .decodingError:
                currentError = .serverError(message: "Unerwartete Antwort vom Server.")
            case .invalidResponse:
                currentError = .networkError()
            }
        } else {
            currentError = .networkError(message: error.localizedDescription)
        }
    }
    
    func clearError() {
        currentError = nil
    }
    
    // MARK: - Authentication
    func register(username: String, password: String) async throws -> RegisterResponseDTO {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let registerData = ["username": username, "password": password]
            
            let resource = try Resource(
                url: Constants.Urls.register,
                method: .post(JSONEncoder().encode(registerData)),
                modelType: RegisterResponseDTO.self
            )
        
            let registerResponseDTO = try await httpClient.load(resource)
            clearError()
            return registerResponseDTO
        } catch {
            handleError(error)
            throw error
        }
    }
    
    func login(username: String, password: String) async throws -> LoginResponseDTO {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let loginPostData = ["username": username, "password": password]
            
            let resource = try Resource(
                url: Constants.Urls.login,
                method: .post(JSONEncoder().encode(loginPostData)),
                modelType: LoginResponseDTO.self
            )
            
            let loginResponseDTO = try await httpClient.load(resource)
            
            if !loginResponseDTO.error && loginResponseDTO.token != nil && loginResponseDTO.userId != nil {
                let defaults = UserDefaults.standard
                defaults.set(loginResponseDTO.token!, forKey: "authToken")
                defaults.set(loginResponseDTO.userId!.uuidString, forKey: "userId")
                clearError()
            } else if let reason = loginResponseDTO.reason {
                currentError = .validationError(message: reason)
            }
            
            return loginResponseDTO
        } catch {
            handleError(error)
            throw error
        }
    }
    
    // MARK: - Grocery Categories
    func populateGroceryCategories() async throws {
        guard let userId = UserDefaults.standard.userId else {
            currentError = .authenticationError()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resource = Resource(
                url: Constants.Urls.groceryCategoriesBy(userId: userId),
                modelType: [GroceryCategoryResponseDTO].self
            )
            
            groceryCategories = try await httpClient.load(resource)
            clearError()
        } catch {
            handleError(error)
            throw error
        }
    }
    
    func saveGroceryCategory(_ groceryCategoryRequestDTO: GroceryCategoryRequestDTO) async throws {
        guard let userId = UserDefaults.standard.userId else {
            currentError = .authenticationError()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resource = try Resource(
                url: Constants.Urls.saveGroceryCategoryBy(userId: userId),
                method: .post(JSONEncoder().encode(groceryCategoryRequestDTO)),
                modelType: GroceryCategoryResponseDTO.self
            )
            
            let groceryCategory = try await httpClient.load(resource)
            groceryCategories.append(groceryCategory)
            clearError()
        } catch {
            handleError(error)
            throw error
        }
    }
    
    func deleteGroceryCategory(groceryCategoryId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            currentError = .authenticationError()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resource = Resource(
                url: Constants.Urls.deleteCategoriesBy(groceryCategoryId: groceryCategoryId, userId: userId),
                method: .delete,
                modelType: GroceryCategoryResponseDTO.self
            )
            
            let deletedGroceryCategory = try await httpClient.load(resource)
            groceryCategories = groceryCategories.filter { $0.id != deletedGroceryCategory.id }
            clearError()
        } catch {
            handleError(error)
            throw error
        }
    }
    
    // MARK: - Grocery Items
    func populateGroceryItemsBy(groceryCategoryId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            currentError = .authenticationError()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resource = Resource(
                url: Constants.Urls.groceryItemsBy(userId: userId, groceryCategoryId: groceryCategoryId),
                modelType: [GroceryItemResponseDTO].self
            )
            
            groceryItems = try await httpClient.load(resource)
            clearError()
        } catch {
            handleError(error)
            throw error
        }
    }
    
    func saveGroceryItem(_ groceryItemRequestDTO: GroceryItemRequestDTO, groceryCategoryId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            currentError = .authenticationError()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resource = try Resource(
                url: Constants.Urls.saveGroceryItem(userId: userId, groceryCategoryId: groceryCategoryId),
                method: .post(JSONEncoder().encode(groceryItemRequestDTO)),
                modelType: GroceryItemResponseDTO.self
            )
            
            let newGroceryItem = try await httpClient.load(resource)
            groceryItems.append(newGroceryItem)
            clearError()
        } catch {
            handleError(error)
            throw error
        }
    }
    
    func deleteGroceryItem(groceryCategoryId: UUID, groceryItemId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            currentError = .authenticationError()
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resource = Resource(
                url: Constants.Urls.deleteCategoriesBy(groceryCategoryId: groceryCategoryId, userId: userId),
                method: .delete,
                modelType: GroceryItemResponseDTO.self
            )

            let deletedGroceryItem = try await httpClient.load(resource)
            groceryItems = groceryItems.filter { $0.id != deletedGroceryItem.id }
            clearError()
        } catch {
            handleError(error)
            throw error
        }
    }
}
