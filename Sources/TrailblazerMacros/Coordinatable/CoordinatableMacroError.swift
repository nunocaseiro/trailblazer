//
//  CoordinatableMacroError.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

enum CoordinatableMacroError: Error, CustomStringConvertible {
    case notAClass
    case notACoordinatorClass
    
    var description: String {
        return
            switch self {
            case .notAClass:
                "The @Coordinatable macro can only be applied to a class."
            case .notACoordinatorClass:
                "The @Coordinatable macro can only be applied to a class that inherits from a coordinator."
            }
    }
}
