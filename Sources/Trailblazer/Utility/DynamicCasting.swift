//
//  DynamicCasting.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftUI

public extension View {
    func environmentObjectIfPossible(_ object: Any) -> some View {
        guard let observableObject = (object as? (any ObservableObject)) else {
            return AnyView(self)
        }
        return AnyView((self.environmentObject(observableObject) as any View))
    }
}
