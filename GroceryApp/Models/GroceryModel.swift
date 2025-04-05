//
//  GroceryModel.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 05.04.25.
//

import Foundation
import Observation

@Observable
class GroceryModel {
    func register(username: String, password: String) async throws -> Bool {
        
        let httpClient = HTTPClient()
        
        let registerData = ["username": username, "password": password]
        let resource = try Resource(url: Constants.Urls.register, method: .post(JSONEncoder().encode(registerData)), modelType: RegisterResponseDTO.self)
        
        let registerResponseDTO = try await httpClient.load(resource)
        
        return !registerResponseDTO.error
    }
}
