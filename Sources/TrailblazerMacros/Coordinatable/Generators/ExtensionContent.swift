//
//  ExtensionContent.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CoordinatableMacro {
    static func generateExtensionContent(className: String, routeMethods: [FunctionDeclSyntax]) -> String {
        let routesEnumCases = generateRoutesEnumCases(routeMethods: routeMethods)
        let referencedEnumCases = generateReferencedRoutesEnumCases(className: className, routeMethods: routeMethods)
        let getReferencedRouteCases = generateGetReferencedRouteCases(routeMethods: routeMethods)
        let createRouteWrapperCases = generateCreateRouteWrapperCases(routeMethods: routeMethods)
        
        return """
        enum Routes {
            \(routesEnumCases)
        }

        enum ReferencedRoutes {
            \(referencedEnumCases)
        }

        func getReferencedRoute(from dereferenced: Routes) -> ReferencedRoutes {
            switch dereferenced {
            \(getReferencedRouteCases)
            }
        }

        func createRouteWrapper(from route: ReferencedRoutes) -> any RouteWrappable {
            switch route {
            \(createRouteWrapperCases)
            }
        }
        """
    }
}
