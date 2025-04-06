//
//  HTTPClient.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import Foundation

// Eigene Fehler-Enum zur Behandlung verschiedener Netzwerkfehlertypen
enum NetworkError: Error {
    case badRequest           // 400er Client-Fehler
    case serverError(String)  // 500er Server-Fehler mit Nachricht
    case decodingError        // JSON-Dekodierungsfehler
    case invalidResponse      // Nicht-HTTP-Antworten oder andere unerwartete Antworttypen
}

// Erweiterung zur Bereitstellung lesbarer Fehlerbeschreibungen
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

// Enum zur Darstellung von HTTP-Methoden mit zugehörigen Daten/Parametern
enum HTTPMethod {
    case get([URLQueryItem])  // GET mit optionalen Abfrageparametern
    case post(Data?)          // POST mit optionalen Body-Daten
    case delete               // DELETE-Methode
    
    // Eigenschaft zum Abrufen der String-Darstellung der HTTP-Methode
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

// Generische Resource-Struktur, die einen API-Endpunkt repräsentiert
// T muss Codable entsprechen für automatisches JSON-Parsing
struct Resource<T: Codable> {
    let url: URL                      // Die Endpunkt-URL
    var method: HTTPMethod = .get([]) // Standardmethode ist GET ohne Parameter
    var modelType: T.Type             // Der erwartete Antwortmodelltyp
}

// HTTP-Client für Netzwerkanfragen mit moderner Swift-Concurrency
struct HTTPClient {
    // Generische Methode, die eine Resource lädt und die dekodierten Daten zurückgibt
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        
        // Konfiguriere die Anfrage basierend auf der HTTP-Methode
        switch resource.method {
        case .get(let queryItems):
            // Für GET-Anfragen füge Query-Parameter an die URL an
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            
            request = URLRequest(url: url)
            
        case .post(let data):
            // Für POST-Anfragen setze die Methode und füge Body-Daten an
            request.httpMethod = resource.method.name
            request.httpBody = data
            
        case .delete:
            // Für DELETE-Anfragen setze nur die Methode
            request.httpMethod = resource.method.name
        }
        
        // Erstelle eine Standard-URL-Session-Konfiguration
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        let session = URLSession(configuration: configuration)
        
        // Führe die Netzwerkanfrage mit async/await aus
        let (data, response) = try await session.data(for: request)
        
        // Überprüfe, ob wir eine HTTP-Antwort erhalten haben
        guard let _ = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Versuche, die Antwortdaten in den erwarteten Modelltyp zu dekodieren
        guard let result = try? JSONDecoder().decode(resource.modelType, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
