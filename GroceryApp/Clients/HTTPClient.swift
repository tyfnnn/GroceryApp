//
//  HTTPClient.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import Foundation

// Custom error enum to handle different types of network errors
enum NetworkError: Error {
    case badRequest           // 400-level client errors
    case serverError(String)  // 500-level server errors with message
    case decodingError        // JSON decoding failures
    case invalidResponse      // Non-HTTP responses or other unexpected response types
}

// Extension to provide human-readable error descriptions
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request", comment: "bad request")
        case .serverError(let message):
            return NSLocalizedString("Server Error: \(message)", comment: "server error")
        case .decodingError:
            return NSLocalizedString("Decoding Error", comment: "decoding error")
        case .invalidResponse:
            return NSLocalizedString("Invalid Response", comment: "invalid response")
        }
    }
}

// Enum representing HTTP methods with associated data/parameters
enum HTTPMethod {
    case get([URLQueryItem])  // GET with optional query parameters
    case post(Data?)          // POST with optional body data
    case delete               // DELETE method
    
    // Property to get the string representation of the HTTP method
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

// Generic resource struct that represents an API endpoint
// T must conform to Codable for automatic JSON parsing
struct Resource<T: Codable> {
    let url: URL                     // The endpoint URL
    var method: HTTPMethod = .get([]) // Default method is GET with no parameters
    var modelType: T.Type            // The expected response model type
}

// HTTP client for making network requests using modern Swift concurrency
struct HTTPClient {
    // Generic method that loads a resource and returns the decoded data
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        
        // Configure the request based on the HTTP method
        switch resource.method {
        case .get(let queryItems):
            // For GET requests, append query items to the URL
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            
            request = URLRequest(url: url)
            
        case .post(let data):
            // For POST requests, set the method and attach body data
            request.httpMethod = resource.method.name
            request.httpBody = data
            
        case .delete:
            // For DELETE requests, just set the method
            request.httpMethod = resource.method.name
        }
        
        // Create a default URL session configuration
        let configuration = URLSessionConfiguration.default
        
        // Initialize a URL session with the configuration
        let session = URLSession(configuration: configuration)
        
        // Make the network request using async/await
        let (data, response) = try await session.data(for: request)
        
        // Validate that we got an HTTP response
        guard let _ = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Attempt to decode the response data into the expected model type
        guard let result = try? JSONDecoder().decode(resource.modelType, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
