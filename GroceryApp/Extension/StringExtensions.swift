//
//  StringExtensions.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 04.04.25.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
