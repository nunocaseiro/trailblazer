<p align="center">
  <img src="./Images/wordmark.svg" alt="Trailblazer" width="100%">
</p>

[![Language](https://img.shields.io/static/v1.svg?label=language&message=Swift%205.9&color=FA7343&logo=swift&style=flat-square)](https://swift.org)
[![Platform](https://img.shields.io/static/v1.svg?label=platforms&message=iOS%20|%20tvOS%20|%20watchOS%20|%20macOS&logo=apple&style=flat-square)](https://apple.com)
[![License](https://img.shields.io/cocoapods/l/Crossroad.svg?style=flat-square)](https://github.com/dotaeva/trailblazer/blob/main/LICENSE)

Trailblazer is a powerful, flexible, Macro-powered navigation framework for SwiftUI applications. It provides a clean, declarative (and blazingly fast!) way to manage complex navigation flows and deep linking across iOS, tvOS, watchOS and macOS devices.

# Why? 🤔

Despite the native SwiftUI navigation being better than at the time of release, it's still not ideal. It's slow and repetetive, especially in applications with larger sizes with MVVM architectural pattern - there's no clear, single way of defining routes in a single place - and don't even get me started on deeplinking.

A solution is to use MVVM-C pattern - adding that extra Coordinator layer solves most of the issues. An inspiration for creating Trailblazer stems from [Stinsen](https://github.com/rundfunk47/stinsen/), which is unfortunately not kept up to date anymore, causing issues in latest versions of iOS, such as memory-leaks or dismissal of modals upon putting the application into the background, creating some pesky scenarios. But here goes the issue - with traditional coordinators, as well as Stinsen, there's lots of repetetive boilerplate code that can be mitigated, and that's where Trailblazer comes into play.

Trailblazer is macro-powered, meaning all the necessary boilerplate code for it to work as smooth as possible is generated in the background. It's also built on top of the latest versions of iOS using native SwiftUI for the best experience.

# Installation 🛠️

Trailblazer is available through SPM.

# Requirements 📋

- iOS 16.4+
- macOS 14.0+
- tvOS 16.0+
- watchOS 9.0+
- Xcode 15.0+ (Recommended XCode 16.0+)
- Swift 5.9+

# Usage 🧑‍💻

## Defining a navigation coordinator

1. Create a coordinator class that inherits from `NavigationCoordinator`:
   
```swift
@Coordinatable
class AppCoordinator: NavigationCoordinator {
    @Route func home() -> some View { HomeView() }
    @Route func detail(_ s: String) -> some View { DetailView(string: s) }
    @Route func setting() -> any Coordinatable { SettingsCoordinator() }

    override init() {
        super.init()
        self.setRoot(.home)
    }
}
```

2. Use the newly defined coordinator at the base of your application, or inside a TabView, as per Apple guidelines:

```swift
struct ContentView: View {
    @StateObject var coordinator = AppCoordinator()
    
    var body: some View {
        coordinator.view
    }
}
```

3. Retrieve the routes' coordinator using the `@EnvironmentObject`:

```swift
struct HomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            Button("To the detail foo!") {
                coordinator.route(to: .detail("foo"))
            }

            Button("Present settings as a sheet") {
                coordinator.present(.settings, as: .sheet)
            }

            /* ... */
        }
    }
}
```

## Macros

Trailblazer uses Swift macros to simplify the creation of coordinators and routes.

### @Coordinatable

The `@Coordinatable` macro is used to annotate your coordinator classes. It automatically generates the necessary boilerplate code for routing and navigation.

```swift
@Coordinatable
class AppCoordinator: NavigationCoordinator {
    // Your coordinator methods here
}
```

Functionality:
- Generates `Routes` enum from defined `@Route`s
- Implements `createRouteWrapper(from:)` methods from defined `@Route`s
- Conforms the class to the respective `Coordinatable`

### @Route

The `@Route` macro is used to annotate methods in your coordinator that represent navigation destinations.

```swift
@Route func detailView(id: Int) -> some View {
    DetailView(id: id)
}
```

Functionality:
- Marks a method as a navigation destination for the `@Coordinatable` macro, making it usable as an enum when routing

Limitations:
- Can only be applied to methods
- The method must return either `some View` or `any Coordinatable`

Using these macros significantly reduces boilerplate code and enforces a consistent structure for your navigation logic.

## Detailed usage

Trailblazer provides several Coordinator type for navigation:

### NavigationCoordinator

NavigationCoordinator implements NavigationStack.

Supported `@Route` return types:
- `some View`
- `any Coordinatable`

Functions:

- `setRoot` - Sets a new root view for the navigation stack.
- `route` - Navigates to another route.
- `present` - Presents route modally (sheet or fullScreenCover).
- `pop` - Removes the latest route from the stack.
- `popToRoot` - Clears the stack.
- `popToFirst` - Removes all routes above the first appearance of a specific route in the stack.
- `popToLast` - Removes all routes above the last appearance of a specific route in the stack.

Example above.

### TabCoordinator

TabCoordinator implements TabView.

Supported `@Route` return types:
- `some View` - Generates a tab where content will be returned type and TabItem will be EmptyView()
- `any Coordinatable` - Generates a tab where content will be returned type and TabItem will be EmptyView()
- `(some View, some View)` - Generates a tab where content will be first tuple item and TabItem will be the second tuple item
- `(any Coordinatable, some View)` - Generates a tab where content will be first tuple item and TabItem will be the second tuple item

Functions:

- `select(_ tab)` - Selects a tab based on its route type.
- `select(index)` - Selects a tab based on its index in the tabs array.
- `setTabs` - Replaces the current tabs with a new set of tabs.
- `appendTab` - Adds a new tab to the end of the tabs array.
- `insertTab` - Inserts a new tab at a specified index in the tabs array.
- `removeFirst`- Removes the first occurrence of a tab with the specified route.
- `removeLast`- Removes the last occurrence of a tab with the specified route.

Example:
```swift
@Coordinatable
class AuthenticatedCoordinator: TabCoordinator {
    @Route func home() -> (any Coordinatable, some View) { ( HomeCoordinator(), Text("Home") ) }
    @Route func settings() -> (any Coordinatable, some View) { ( SettingsCoordinator(), Text("Settings") ) }
    
    override init() {
        super.init()
        setTabs([
            .home,
            .settings
        ])
    }
}
```

### RootCoordinator

RootCoordinator implements a simple view-switching coordinator without implementing a NavigationStack.

Supported `@Route` return types:
- `some View`
- `any Coordinatable`

Functions:

- `setRoot` - Sets a new root view.

Example:
```swift
@Coordinatable
class UnauthenticatedCoordinator: RootCoordinator {
    @Route func login() -> some View { Button("Log in!") { self.setRoot(.authenticated) } }
    @Route func authenticated() -> any Coordinatable { AuthenticatedCoordinator() }
    
    override init() {
        super.init()
        setRoot(.login)
    }
}

```

# Advanced Features 🚀

## Modifiers

Customize view using the `with` parameter upon routing or presenting:

```swift
coordinator.route(to: .detail(id: 1), with: { view in
    view.backgroundColor(.red)
})
```

## Nested Coordinators

Create complex navigation hierarchies using nested coordinators:

```swift
@Coordinatable
class MainCoordinator: NavigationCoordinator {
    @Route func settings() -> any Coordinatable {
        SettingsCoordinator()
    }
}
```

## Chaining

Trailblazer supports method chaining for more complex navigation flows:

```swift
coordinator
    .route(to: .detail(id: 1))
    .route(to: .settings)
```

## Deep Linking

Handle deep links by calling the appropriate navigation methods:

```swift
func handleDeepLink(_ url: URL) {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
          let path = components.path.split(separator: "/").first else {
        return
    }
    
    switch path {
    case "detail":
        if let id = components.queryItems?.first(where: { $0.name == "id" })?.value,
           let idInt = Int(id) {
            coordinator.route(to: .detail(id: idInt))
        }
    case "settings":
        coordinator.route(to: .settings)
    default:
        break
    }
}
```

# License 📃

Trailblazer is released under the MIT license. See [LICENSE](https://github.com/dotaeva/trailblazer/blob/main/LICENSE) for details.
