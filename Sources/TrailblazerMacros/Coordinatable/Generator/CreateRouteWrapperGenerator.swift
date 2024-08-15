//
//  CreateRouteWrapperGenerator.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftSyntax

struct CreateRouteWrapperGenerator {
    static func generate(
        routeMethods: [FunctionDeclSyntax],
        coordinatorType: CoordinatorType
    ) -> String {
        routeMethods.map { method in
            let returnType = RouteReturnTypeResolver.resolve(from: method.signature.returnClause)
            
            switch coordinatorType {
            case .navigation, .root:
                return generateNavigationCoordinatorCase(method: method, returnType: returnType)
            case .tab:
                return generateTabCoordinatorCase(method: method, returnType: returnType)
            default: break
            }
            
            return String()
        }.joined(separator: "\n    ")
    }
}

extension CreateRouteWrapperGenerator {
    private static func generateTabCoordinatorCase(
        method: FunctionDeclSyntax,
        returnType: RouteReturnType)
    -> String {
        let parameters = resolveParameters(from: method)
        let methodName = method.name.text
        
        let caseDeclaration = parameters.isEmpty
        ? "case .\(methodName):"
        : "case .\(methodName)(\(parameters)):"
        
        let caseContent =
        switch returnType {
        case .view, .viewView:
            generateViewTabCoordinatorWrapper(method: method, returnType: returnType)
        case .coordinatable, .coordinatableView:
            generateCoordinatorTabCoordinatorWrapper(method: method, returnType: returnType)
        default: String();
        }
        
        return """
        \(caseDeclaration)
            \(caseContent)
        """
    }
    
    private static func generateViewTabCoordinatorWrapper(
        method: FunctionDeclSyntax,
        returnType: RouteReturnType
    ) -> String {
        let arguments = resolveArguments(from: method)
        let methodName = method.name.text
        
        let lazyVarContent =
        switch returnType {
        case .view:
            "self.\(methodName)(\(arguments)), EmptyView()"
        case .viewView:
            "self.\(methodName)(\(arguments))"
        default: String()
        }
        
        return """
            lazy var v: (some View, some View) = { ( \(lazyVarContent) ) }()
                return prepareViewWrapper(route: route, view: AnyView(v.0), tabItem: AnyView(v.1))
        """
    }
    
    private static func generateCoordinatorTabCoordinatorWrapper(
        method: FunctionDeclSyntax,
        returnType: RouteReturnType
    ) -> String {
        let arguments = resolveArguments(from: method)
        let methodName = method.name.text
        
        let coordinatorFactoryContent =
        switch returnType {
        case .coordinatable:
            "self.\(methodName)(\(arguments))"
        case .coordinatableView:
            "self.\(methodName)(\(arguments)).0"
        default: String()
        }
        
        let tabItemContent =
        switch returnType {
        case .coordinatable:
            "EmptyView()"
        case .coordinatableView:
            if let tuple = method.body?.statements.first?.item.as(TupleExprSyntax.self) {
                "\(tuple.elements.last?.description ?? "")"
            } else {
                "EmptyView()"
            }
        default: ""
        }
        
        return """
        return prepareCoordinatorWrapper(route: route, coordinatorFactory: { \(coordinatorFactoryContent) }, tabItem: AnyView(\(tabItemContent)))
        """
    }
    
    private static func generateNavigationCoordinatorCase(
        method: FunctionDeclSyntax,
        returnType: RouteReturnType
    ) -> String {
        let parameters = resolveParameters(from: method)
        let arguments = resolveArguments(from: method)
        
        let methodName = method.name.text
        let caseDeclaration = parameters.isEmpty ? "case .\(methodName):" : "case .\(methodName)(\(parameters)):"
        
        if returnType == .view {
            return """
                \(caseDeclaration)
                        return RouteWrapper(parent: self, route: route, view: AnyView(\(methodName)(\(arguments))))
            """
        } else if returnType == .coordinatable {
            return """
                \(caseDeclaration)
                        return RouteWrapper(parent: self, route: route, coordinator: \(methodName)(\(arguments)))
            """
        } else {
            return """
                \(caseDeclaration)
                        return RouteWrapper(parent: self, route: route, view: EmptyView())
            """
        }
    }
}

extension CreateRouteWrapperGenerator {
    private static func resolveParameters(from clause: FunctionDeclSyntax) -> String {
        clause.signature.parameterClause.parameters.enumerated().map { index, param in
            if param.firstName.text == "_" {
                return "let arg\(index)"
            } else {
                return "let \(param.firstName)"
            }
        }.joined(separator: ", ")
    }
    
    private static func resolveArguments(from clause: FunctionDeclSyntax) -> String {
        clause.signature.parameterClause.parameters.enumerated().map { index, param in
            if param.firstName.text == "_" {
                return "arg\(index)"
            } else {
                return "\(param.firstName): \(param.firstName)"
            }
        }.joined(separator: ", ")
    }
}
