//
//  MacroError.swift
//
//
//  Created by Alexandr Valíček on 24.07.2024.
//

enum MacroError: Error, CustomStringConvertible {
    case notAClass
    case notAFunction
    case invalidRouteReturnType(methodName: String, returnType: String)

    var description: String {
        switch self {
        case .notAClass:
            return "The @Coordinatable macro can only be applied to a class."
        case .notAFunction:
            return "The @Route macro can only be applied to a function."
        case .invalidRouteReturnType(let methodName, let returnType):
            return "Invalid return type for route method '\(methodName)'. Expected 'some View' or 'any Coordinatable', but got '\(returnType)'."
        }
    }
}
