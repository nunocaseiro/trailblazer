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
                @Route func detail(_ string: String) -> some View { Button(string) { self.route(to: .setting) } }
                @Route func setting() -> any Coordinatable { SettingRouter() }
            }
            """,
            expandedSource: """
            class AppRouter: NavigationCoordinator {
                func root() -> some View { Text("Root") }
                func detail(_ string: String) -> some View { Button(string) { self.route(to: .setting) } }
                func setting() -> any Coordinatable { SettingRouter() }
            }
            
            extension AppRouter: NavigationCoordinatable {
                enum Routes {
                    case root
                    case detail(String)
                    case setting
                }
                func createRouteWrapper(from route: Routes) -> any RouteWrappable {
                    switch route {
                        case .root:
                            return RouteWrapper(parent: self, route: route, view: AnyView(root()))
                        case .detail(let arg0):
                            return RouteWrapper(parent: self, route: route, view: AnyView(detail(arg0)))
                        case .setting:
                            return RouteWrapper(parent: self, route: route, coordinator: setting())
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

    func testRootRouterExpansion() throws {
        #if canImport(TrailblazerMacros)
        assertMacroExpansion(
            """
            @Coordinatable
            class RootRouter: NavigationCoordinator {
                @Route func root() -> some View { Text("Root") }
            }
            """,
            expandedSource: """
            class RootRouter: NavigationCoordinator {
                func root() -> some View { Text("Root") }
            }
            
            extension RootRouter: NavigationCoordinatable {
                enum Routes {
                    case root
                }
                func createRouteWrapper(from route: Routes) -> any RouteWrappable {
                    switch route {
                        case .root:
                            return RouteWrapper(parent: self, route: route, view: AnyView(root()))
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
