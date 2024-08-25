//
//  NoteDetailView.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import SwiftUI

struct NoteDetailView: View {
    let note: Notes
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(note.text)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle(note.name)
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: Notes(name: "Foo", text: "Bar"))
    }
}
