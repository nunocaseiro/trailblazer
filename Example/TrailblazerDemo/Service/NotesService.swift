//
//  NotesService.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import SwiftUI
import Observation

@Observable
class NotesService {
    var data: [Notes] = [
        Notes(name: "Some note", text: "Some description"),
        Notes(name: "Yet another note", text: "Yet another description"),
    ]
}

extension NotesService {
    func create(_ note: Notes) {
        data.append(note)
    }
    
    func remove(_ note: Notes) {
        data.removeAll(where: { $0.id == note.id })
    }
}
