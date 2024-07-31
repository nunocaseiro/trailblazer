import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(TrailblazerMacros)
import TrailblazerMacros

let testMacros: [String: Macro.Type] = [
    "Coordinatable": CoordinatableMacro.self,
    "Route": RouteMacro.self,
]
#endif

final class TrailblazerTests: XCTestCase {
    
    func testAppRouterExpansion() throws {
        #if canImport(TrailblazerMacros)
        assertMacroExpansion(
            """
            @Coordinatable
            class AppRouter: NavigationCoordinator {
                @Route func root() -> some View { Text("Root") }
                @Route func detail(_ string: String) -> some View { Button(string) { self.route(to: .setting(s: SettingsRouter())) } }
                @Route func setting(s: SettingsRouter) -> any Coordinatable { s }
            }
            """,
            expandedSource: """
            class AppRouter: NavigationCoordinator {
                func root() -> some View { Text("Root") }
                func detail(_ string: String) -> some View { Button(string) { self.route(to: .setting(s: SettingsRouter())) } }
                func setting(s: SettingsRouter) -> any Coordinatable { s }
            }
            
            extension AppRouter: NavigationCoordinatable {
                enum Routes {
                    case root
                    case detail(String)
                    case setting(s: SettingsRouter)
                }
                enum ReferencedRoutes {
                    case root(AppRouter)
                    case detail(AppRouter, String)
                    case setting(AppRouter, s: SettingsRouter)
                }
                func getReferencedRoute(from dereferenced: Routes) -> ReferencedRoutes {
                    switch dereferenced {
                    case .root:
                        return .root(self)
                    case .detail(let string):
                        return .detail(self, string)
                    case .setting(let s):
                        return .setting(self, s: s)
                    }
                }
                func createRouteWrapper(from route: ReferencedRoutes) -> any RouteWrappable {
                    switch route {
                    case .root(_):
                        return RouteWrapper(route: route, view: root())
                    case .detail(_, let arg0):
                        return RouteWrapper(route: route, view: detail(arg0))
                    case .setting(_, let s):
                        return RouteWrapper(route: route, coordinator: setting(s: s))
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testSettingsRouterExpansion() throws {
        #if canImport(TrailblazerMacros)
        assertMacroExpansion(
            """
            @Coordinatable
            class SettingsRouter: NavigationCoordinator {
                @Route func root() -> some View { Text("Root") }
            }
            """,
            expandedSource: """
            class SettingsRouter: NavigationCoordinator {
                func root() -> some View { Text("Root") }
            }
            
            extension SettingsRouter: NavigationCoordinatable {
                enum Routes {
                    case root
                }
                enum ReferencedRoutes {
                    case root(SettingsRouter)
                }
                func getReferencedRoute(from dereferenced: Routes) -> ReferencedRoutes {
                    switch dereferenced {
                    case .root:
                        return .root(self)
                    }
                }
                func createRouteWrapper(from route: ReferencedRoutes) -> any RouteWrappable {
                    switch route {
                    case .root(_):
                        return RouteWrapper(route: route, view: root())
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testCoordinatableErrorNotAClass() throws {
        #if canImport(TrailblazerMacros)
        assertMacroExpansion(
            """
            @Coordinatable
            struct NotAClass {}
            """,
            expandedSource: """
            struct NotAClass {}
            """,
            diagnostics: [
                DiagnosticSpec(message: "The @Coordinatable macro can only be applied to a class.", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testRouteErrorNotAFunction() throws {
        #if canImport(TrailblazerMacros)
        assertMacroExpansion(
            """
            class TestClass {
                @Route var notAFunction: Int = 0
            }
            """,
            expandedSource: """
            class TestClass {
                var notAFunction: Int = 0
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "The @Route macro can only be applied to a function.", line: 2, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testRouteErrorInvalidReturnType() throws {
        #if canImport(TrailblazerMacros)
        assertMacroExpansion(
            """
            class TestClass {
                @Route func invalidReturnType() -> String { return "Invalid" }
            }
            """,
            expandedSource: """
            class TestClass {
                func invalidReturnType() -> String { return "Invalid" }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Invalid return type for route method 'invalidReturnType'. Expected 'some View' or 'any Coordinatable', but got 'String'.", line: 2, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
