//
//  MacroError.swift
//
//
//  Created by Alexandr Valíček on 24.07.2024.
//

import SwiftDiagnostics

enum RouteMacroError: Error, CustomStringConvertible {
    case notAFunction
    case invalidRouteReturnTypeFallback(methodName: String, returnType: String)
    case invalidRouteReturnTypeGeneric(methodName: String, returnType: String)
    case invalidRouteReturnTypeTab(methodName: String, returnType: String)
    case notInsideClass
    case missingCoordinatableAttribute
    
    case debug(String)
    
    var description: String {
        return
            switch self {
            case.debug(let str): str
            case .notAFunction:
                "The @Route macro can only be applied to a function."
            case .invalidRouteReturnTypeFallback(let methodName, let returnType):
                "Invalid return type for route method '\(methodName)'. Expected 'some View' or 'any Coordinatable' for NavigationCoordinator and RootCoordinator, or additionally '(some View, some View)' or '(any Coordinatable, some View)' for TabCoordinator, but got '\(returnType)'."
            case .invalidRouteReturnTypeGeneric(let methodName, let returnType):
                "Invalid return type for route method '\(methodName)'. Expected 'some View' or 'any Coordinatable', but got '\(returnType)'."
            case .invalidRouteReturnTypeTab(let methodName, let returnType):
                "Invalid return type for route method '\(methodName)'. Expected 'some View', 'any Coordinatable', '(some View, some View)' or '(any Coordinatable, some View)', but got '\(returnType)'."
            case .notInsideClass:
                "The @Route macro can only be applied to functions inside a class."
            case .missingCoordinatableAttribute:
                "The class containing the @Route macro must have the @Coordinatable attribute."
            }
    }
}
