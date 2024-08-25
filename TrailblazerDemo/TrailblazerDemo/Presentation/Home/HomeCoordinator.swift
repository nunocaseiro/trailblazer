//
//  HomeCoordinator.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import Trailblazer
import SwiftUI

@Coordinatable
final class HomeCoordinator: NavigationCoordinator {
    @Route func root() -> some View { HomeView(notesService: _notesService) }
    @Route func noteAdd(notesService: NotesService) -> some View { AddNoteView(notesService: notesService) }
    @Route func noteDetail(note: Notes) -> some View { NoteDetailView(note: note) }
    @Route func settings() -> any Coordinatable { SettingsCoordinator() }
    
    private var _notesService = NotesService()
    
    override init() {
        super.init()
        setRoot(.root)
    }
}
