import SwiftUI
import Trailblazer

@Coordinatable
class AppRouter: NavigationCoordinator {
    @Route func root() -> some View { Text("Root") }
    @Route func detail(_ string: String) -> some View { Button(string) { self.route(to: .setting(s: SettingsRouter())) } }
    @Route func setting(s: SettingsRouter) -> any Coordinatable { s }
}

@Coordinatable
class SettingsRouter: NavigationCoordinator {
    @Route func root() -> some View { Text("Root") }
}
