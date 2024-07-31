//
//  ReferencedRoutesEnumCases.swift
//
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CoordinatableMacro {
    static func generateReferencedRoutesEnumCases(className: String, routeMethods: [FunctionDeclSyntax]) -> String {
        routeMethods.map { method in
            let parameters = method.signature.parameterClause.parameters.map { param in
                if param.firstName.text == "_" {
                    return "\(param.type)"
                } else {
                    return "\(param.firstName.text): \(param.type)"
                }
            }.joined(separator: ", ")
            
            if parameters.isEmpty {
                return "case \(method.name)(\(className))"
            } else {
                return "case \(method.name)(\(className), \(parameters))"
            }
        }.joined(separator: "\n    ")
    }
}
