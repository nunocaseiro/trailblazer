//
//  CoordinatableMacro.swift
//
//
//  Created by Alexandr Valíček on 24.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CoordinatableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw CoordinatableMacroError.notAClass
        }
        
        let className = classDecl.name.text
        
        let coordinatorType = CoordinatorTypeResolver.resolve(from: classDecl)
        
        if coordinatorType == .none {
            throw CoordinatableMacroError.notACoordinatorClass
        }
        
        let routeMethods = RouteMethodExtractor.extract(from: classDecl)
        
        if routeMethods.isEmpty { return [] }
        
        let extensionContent = ExtensionContentGenerator.generate(className: className, routeMethods: routeMethods, coordinatorType: coordinatorType)
        
        let conformanceProtocol = coordinatorType.rawValue
        
        let extensionDeclString = """
        extension \(type.trimmed): \(conformanceProtocol) {
        \(extensionContent.split(separator: "\n").map { "    \($0)" }.joined(separator: "\n"))
        }
        """

        return try [ExtensionDeclSyntax(SyntaxNodeString(stringLiteral: extensionDeclString))]
    }
}
