//
//  ColorSelector.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 30.05.25.
//

import SwiftUI

enum Colors: String, CaseIterable {
    case green = "#2ecc71"
    case red = "#e74c3c"
    case yellow = "#f1c40f"
    case blue = "#3498db"
    case purple = "#9b59b6"
    case orange = "#f39c12"
    case pink = "#e91e63"
}

struct ColorSelector: View {
    @Binding var colorCode: String
    
    var body: some View {
        HStack {
            ForEach(Colors.allCases, id: \.rawValue) { color in
                VStack {
                    Image(systemName: colorCode == color.rawValue ? "record.circle.fill" : "circle.fill")
                        .font(.title)
                        .foregroundColor(Color.fromHex(color.rawValue))
                        .clipShape(Circle())
                        .onTapGesture {
                            colorCode = color.rawValue
                        }
                }
                
            }
        }
    }
}

#Preview {
    ColorSelector(colorCode: .constant("#2ecc71"))
}
