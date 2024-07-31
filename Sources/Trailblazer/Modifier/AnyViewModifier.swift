//
//  AnyViewModifier.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftUI

public struct AnyViewModifier: ViewModifier {
    let modify: (AnyView) -> AnyView

    public func body(content: Content) -> some View {
        modify(AnyView(content))
    }

    static var identity: AnyViewModifier {
        AnyViewModifier { $0 }
    }
}

