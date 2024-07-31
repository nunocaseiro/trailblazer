//
//  TrailblazerMacro.swift
//
//
//  Created by Alexandr Valíček on 20.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct NavigationMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CoordinatableMacro.self,
        RouteMacro.self,
    ]
}
