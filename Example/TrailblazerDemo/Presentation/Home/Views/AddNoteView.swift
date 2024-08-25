//
//  AddNoteView.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    
    var notesService: NotesService
    
    @State var noteName = String()
    @State var noteText = String()
    
    var body: some View {
        Form {
            Section {
                TextField("Note Name", text: $noteName)
                TextField("Note Text", text: $noteText)
            }
            
            Button("Create note") {
                notesService.create(
                    Notes(
                        name: noteName,
                        text: noteText
                    ))
                dismiss()
            }
        }
        .navigationTitle("Create note")
    }
}
#Preview {
    NavigationStack {
        AddNoteView(notesService: NotesService())
    }
}
