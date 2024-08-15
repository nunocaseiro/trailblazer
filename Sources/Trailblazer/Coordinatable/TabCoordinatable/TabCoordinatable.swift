//
//  TabCoordinatable.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

public protocol TabCoordinatable: Coordinatable {
    var root: TabRouteWrapper? { get set }
    var tabs: [TabRouteWrapper] { get set }
    var selectedTab: TabRouteWrapper? { get set }
}
