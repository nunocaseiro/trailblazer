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
    
    /// Selects a tab based on its index in the tabs array.
    /// - Parameter index: The index of the tab to be selected.
    func select(index: Int) {
        selectedTab = tabs[index]
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
    
    /// Adds a new tab to the end of the tabs array.
    /// - Parameter tab: The route of the new tab to be added.
    func appendTab(_ tab: Routes) {
        tabs.append(createRouteWrapper(from: tab) as! TabRouteWrapper)
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
