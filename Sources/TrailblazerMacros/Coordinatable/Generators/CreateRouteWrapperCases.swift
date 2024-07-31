//
//  CreateRouteWrapperCases.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CoordinatableMacro {
    static func generateCreateRouteWrapperCases(routeMethods: [FunctionDeclSyntax]) -> String {
        routeMethods.map { method in
            let parameters = method.signature.parameterClause.parameters.enumerated().map { index, param in
                if param.firstName.text == "_" {
                    return "let arg\(index)"
                } else {
                    return "let \(param.firstName)"
                }
            }.joined(separator: ", ")
            
            let arguments = method.signature.parameterClause.parameters.enumerated().map { index, param in
                if param.firstName.text == "_" {
                    return "arg\(index)"
                } else {
                    return "\(param.firstName): \(param.firstName)"
                }
            }.joined(separator: ", ")
            
            let returnType = method.signature.returnClause?.type.description ?? "Void"
            
            if parameters.isEmpty {
                if returnType.contains("some View") {
                    return "case .\(method.name)(_):\n        return RouteWrapper(route: route, view: \(method.name)())"
                } else if returnType.contains("any Coordinatable") {
                    return "case .\(method.name)(_):\n        return RouteWrapper(route: route, coordinator: \(method.name)())"
                } else {
                    return "case .\(method.name)(_):\n        return RouteWrapper(route: route, view: EmptyView())"
                }
            } else {
                if returnType.contains("some View") {
                    return "case .\(method.name)(_, \(parameters)):\n        return RouteWrapper(route: route, view: \(method.name)(\(arguments)))"
                } else {
                    return "case .\(method.name)(_, \(parameters)):\n        return RouteWrapper(route: route, coordinator: \(method.name)(\(arguments)))"
                }
            }
        }.joined(separator: "\n    ")
    }
}
