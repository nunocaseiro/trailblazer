import SwiftUI
import Trailblazer

@Coordinatable
class AppRouter: NavigationCoordinator {
    @Route func root() -> some View { Text("Root") }
    @Route func detail(_ string: String) -> some View { Button(string) { self.route(to: .setting) } }
    @Route func setting() -> any Coordinatable { SettingRouter() }
}

@Coordinatable
class SettingRouter: RootCoordinator {
    @Route func root() -> some View { Text("Root") }
}

@Coordinatable
class TabRouter: TabCoordinator {
    @Route func root(str: String) -> some View { Text(str) }
    @Route func detail() -> (some View, some View) { ( Text("Detail") , Text("DetailTabItem")) }
    @Route func settings() -> any Coordinatable { TabRouter() }
    @Route func app() -> (any Coordinatable, some View) { (AppRouter(), Text("App")) }
}

@Coordinatable
class RootRouter: NavigationCoordinator {
    @Route func root() -> some View { Text("Root") }
}
