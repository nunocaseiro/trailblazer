//
//  HomeView.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    
    var notesService: NotesService
    
    var body: some View {
        VStack {
            List {
                ForEach(notesService.data) { note in
                    Button(note.name) {
                        coordinator.route(to: .noteDetail(note: note))
                    }
                }
                .onDelete(perform: deleteNote)
            }
        }
        .navigationTitle("Trailblazer")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        coordinator.present(.noteAdd(notesService: notesService), as: .sheet, with: { view in
                            view
                                .presentationDetents([.medium])
                        })
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Button {
                        coordinator.route(to: .settings)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
#endif
        }
    }
    
    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            notesService.remove(notesService.data[index])
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(notesService: NotesService())
    }
}
