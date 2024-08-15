//
//  RootCoordinatable.swift
//
//
//  Created by Alexandr Valíček on 06.08.2024.
//

import SwiftUI
import Combine

public protocol RootCoordinatable: Coordinatable {
    var root: RouteWrapper? { get set }
}
