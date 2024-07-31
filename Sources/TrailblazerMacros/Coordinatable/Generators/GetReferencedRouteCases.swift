//
//  GetReferencedRouteCases.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CoordinatableMacro {
    static func generateGetReferencedRouteCases(routeMethods: [FunctionDeclSyntax]) -> String {
        routeMethods.map { method in
            let parameters = method.signature.parameterClause.parameters.map { param in
                if param.firstName.text == "_" {
                    return "let \(param.secondName?.text ?? "arg")"
                } else {
                    return "let \(param.firstName)"
                }
            }.joined(separator: ", ")
            
            let arguments = method.signature.parameterClause.parameters.map { param in
                if param.firstName.text == "_" {
                    return param.secondName?.text ?? "arg"
                } else {
                    return "\(param.firstName): \(param.firstName)"
                }
            }.joined(separator: ", ")
            
            if parameters.isEmpty {
                return "case .\(method.name):\n        return .\(method.name)(self)"
            } else {
                return "case .\(method.name)(\(parameters)):\n        return .\(method.name)(self, \(arguments))"
            }
        }.joined(separator: "\n    ")
    }
}
