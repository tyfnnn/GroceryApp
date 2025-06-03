//
//  ErrorWrapper.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 03.06.25.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
}
