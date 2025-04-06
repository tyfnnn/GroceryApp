//
//  GroceryModel.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 05.04.25.
//

import Foundation
import Observation

// @Observable Makro ermöglicht die automatische Verfolgung von Änderungen an diesem Modell
// und benachrichtigt die UI, wenn sich Daten ändern (Teil des Observation-Frameworks)
@Observable
class GroceryModel {
    
    // Erstellen einer Instanz des HTTP-Clients für Netzwerkanfragen
    let httpClient = HTTPClient()
    
    // Funktion zur Benutzerregistrierung, die asynchron arbeitet und möglicherweise Fehler wirft
    // - Parameter username: Benutzername für die Registrierung
    // - Parameter password: Passwort für die Registrierung
    // - Returns: Boolean-Wert, der angibt, ob die Registrierung erfolgreich war (true) oder nicht (false)
    func register(username: String, password: String) async throws -> RegisterResponseDTO {
        

        
        // Erstellen eines Wörterbuchs mit den Registrierungsdaten (Benutzername und Passwort)
        let registerData = ["username": username, "password": password]
        
        // Erstellen einer Resource für die HTTP-Anfrage:
        // - URL: Die Registrierungs-URL aus den Konstanten
        // - Methode: POST mit den kodierten Registrierungsdaten
        // - Erwarteter Antworttyp: RegisterResponseDTO
        let resource = try Resource(
            url: Constants.Urls.register,
            method: .post(JSONEncoder().encode(registerData)),
            modelType: RegisterResponseDTO.self
        )
        
        // Asynchrones Senden der Anfrage und Warten auf die Antwort
        let registerResponseDTO = try await httpClient.load(resource)
        
        // Gibt true zurück, wenn kein Fehler aufgetreten ist, andernfalls false
        // (Beachte die Negation "!" - wir kehren den Fehlerwert um)
        return registerResponseDTO
    }
}
