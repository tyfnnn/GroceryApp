//
//  ErrorView.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 03.06.25.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        VStack {
            Text("An error occurred")
            Text(errorWrapper.guidance)
        }
    }
}


struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case operationFailed
    }
    static var previews: some View {
        ErrorView(errorWrapper: .init(error: SampleError.operationFailed, guidance: "Operation has failed"))
    }
}
