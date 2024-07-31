//
//  NavigationCoordinatable.swift
//  
//
//  Created by Alexandr Valíček on 27.07.2024.
//

import SwiftUI
import Combine

public protocol NavigationCoordinatable: Coordinatable {
    var root: RouteWrapper? { get set }
    var stack: [RouteWrapper] { get set }
    
    var presentedSheet: RouteWrapper? { get set }
    var presentedFullScreenCover: RouteWrapper? { get set }
    var onDismiss: (() -> Void)? { get set }
    
    var flattenedStack: [RouteWrapper] { get }
    var combinedStack: Binding<[RouteWrapper]> { get }
    
    var sharedSheet: Binding<RouteWrapper?> { get }
    var sharedFullScreenCover: Binding<RouteWrapper?> { get }
}
