//
//  TabCoordinatableRouting.swift
//
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

public extension TabCoordinatable {
    /// Selects a tab based on its route type.
    /// - Parameter tab: The route of the tab to be selected.
    func select(_ tab: Routes) {
        selectedTab = tabs.first(where: { String(describing: $0.route.self) == String(describing: tab.self) })
        notifyStackChanged()
    }
    
    /// Selects a tab based on its route type and allows nested coordination.
    /// - Parameters:
    ///   - tab: The route of the tab to be selected.
    ///   - nested: A closure that receives the coordinator of type T for the selected tab and allows nested routing.
    func select<T>(_ tab: Routes, nested perform: ((T) -> Void)? = nil) where T: Coordinatable {
        selectedTab = tabs.first(where: { String(describing: $0.route.self) == String(describing: tab.self) })
        
        if let coordinator = selectedTab?.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
    }
    
    /// Selects a tab based on its index in the tabs array.
    /// - Parameter index: The index of the tab to be selected.
    func select(index: Int) {
        selectedTab = tabs[index]
        notifyStackChanged()
    }
    
    /// Selects a tab based on its index in the tabs array and allows nested coordination.
    /// - Parameters:
    ///   - index: The index of the tab to be selected.
    ///   - nested: A closure that receives the coordinator of type T for the selected tab and allows nested routing.
    func select<T>(index: Int, nested perform: ((T) -> Void)? = nil) where T: Coordinatable {
        selectedTab = tabs[index]
        
        if let coordinator = selectedTab?.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
    }
    
    /// Replaces the current tabs with a new set of tabs.
    /// - Parameter newTabs: An array of Routes representing the new tabs.
    func setTabs(_ newTabs: [Routes]) {
        var _tabs: [TabRouteWrapper] = []
        for tab in newTabs {
            let wrapper = createRouteWrapper(from: tab) as! TabRouteWrapper
            _tabs.append(wrapper)
        }
        tabs = _tabs
        notifyStackChanged()
    }
    
    /// Replaces the current tabs with a new set of tabs and allows nested coordination for each tab.
    /// - Parameters:
    ///   - newTabs: An array of Routes representing the new tabs.
    ///   - nested: A closure that receives the coordinator of type T for each new tab and allows nested routing.
    func setTabs<T>(_ newTabs: [Routes], nested perform: ((T, Int) -> Void)? = nil) where T: Coordinatable {
        var _tabs: [TabRouteWrapper] = []
        for (index, tab) in newTabs.enumerated() {
            let wrapper = createRouteWrapper(from: tab) as! TabRouteWrapper
            _tabs.append(wrapper)
            
            if let coordinator = wrapper.coordinator as? T,
               let perform = perform {
                perform(coordinator, index)
            }
        }
        tabs = _tabs
        notifyStackChanged()
    }
    
    /// Adds a new tab to the end of the tabs array.
    /// - Parameter tab: The route of the new tab to be added.
    func appendTab(_ tab: Routes) {
        tabs.append(createRouteWrapper(from: tab) as! TabRouteWrapper)
        notifyStackChanged()
    }
    
    /// Adds a new tab to the end of the tabs array and allows nested coordination for the new tab.
    /// - Parameters:
    ///   - tab: The route of the new tab to be added.
    ///   - nested: A closure that receives the coordinator of type T for the new tab and allows nested routing.
    func appendTab<T>(_ tab: Routes, nested perform: ((T) -> Void)? = nil) where T: Coordinatable {
        let wrapper = createRouteWrapper(from: tab) as! TabRouteWrapper
        tabs.append(wrapper)
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
    }
    
    /// Inserts a new tab at a specified index in the tabs array.
    /// - Parameters:
    ///   - tab: The route of the new tab to be inserted.
    ///   - index: The index at which to insert the new tab.
    func insertTab(_ tab: Routes, at index: Int) {
        tabs.insert(createRouteWrapper(from: tab) as! TabRouteWrapper, at: index)
        notifyStackChanged()
    }
    
    /// Inserts a new tab at a specified index in the tabs array and allows nested coordination for the new tab.
    /// - Parameters:
    ///   - tab: The route of the new tab to be inserted.
    ///   - index: The index at which to insert the new tab.
    ///   - nested: A closure that receives the coordinator of type T for the new tab and allows nested routing.
    func insertTab<T>(_ tab: Routes, at index: Int, nested perform: ((T) -> Void)? = nil) where T: Coordinatable {
        let wrapper = createRouteWrapper(from: tab) as! TabRouteWrapper
        tabs.insert(wrapper, at: index)
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
    }
    
    /// Removes the first occurrence of a tab with the specified route.
    /// - Parameter tab: The route of the tab to be removed.
    func removeFirst(_ tab: Routes) {
        if let index = tabs.firstIndex(where: {
            return String(describing: $0.route.self) == String(describing: tab.self)
        }) {
            tabs.remove(at: index)
            notifyStackChanged()
        }
    }
    
    /// Removes the last occurrence of a tab with the specified route.
    /// - Parameter tab: The route of the tab to be removed.
    func removeLast(_ tab: Routes) {
        if let index = tabs.lastIndex(where: {
            return String(describing: $0.route.self) == String(describing: tab.self)
        }) {
            tabs.remove(at: index)
            notifyStackChanged()
        }
    }
}
