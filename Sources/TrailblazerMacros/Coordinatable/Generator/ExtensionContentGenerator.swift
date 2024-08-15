//
//  ExtensionContentGenerator.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftSyntax

struct ExtensionContentGenerator {
    static func generate(
        className: String,
        routeMethods: [FunctionDeclSyntax],
        coordinatorType: CoordinatorType
    ) -> String {
        let routesEnumCases = RoutesEnumGenerator.generate(routeMethods: routeMethods)
        let createRouteWrapperCases = CreateRouteWrapperGenerator.generate(routeMethods: routeMethods, coordinatorType: coordinatorType)
        
        return """
        enum Routes {
            \(routesEnumCases)
        }

        func createRouteWrapper(from route: Routes) -> any RouteWrappable {
            switch route {
            \(createRouteWrapperCases)
            }
        }
        """
    }
}
