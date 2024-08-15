//
//  RoutesEnumGenerator.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftSyntax

struct RoutesEnumGenerator {
    static func generate(routeMethods: [FunctionDeclSyntax]) -> String {
        routeMethods.map { method in
            let parameters = method.signature.parameterClause.parameters.map { param in
                if param.firstName.text == "_" {
                    return "\(param.type)"
                } else {
                    return "\(param.firstName.text): \(param.type)"
                }
            }.joined(separator: ", ")
            
            if parameters.isEmpty {
                return "case \(method.name)"
            } else {
                return "case \(method.name)(\(parameters))"
            }
        }.joined(separator: "\n    ")
    }
}
