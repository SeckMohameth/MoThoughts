//
//  ContentView.swift
//  MoThoughts
//
//  Created by Mohameth Seck on 11/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @State private var showingNewNote = false
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            // Notes Tab
            NavigationStack {
                NoteListView(notes: notes)
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("Thoughts")
            }
            .tag(0)
            
            // Folders Tab
            NavigationStack {
                FolderView()
            }
            .tabItem {
                Image(systemName: "folder")
                Text("Folders")
            }
            .tag(1)
        }
        .tint(.blue)
    }
}

// MARK: - NoteListView
struct NoteListView: View {
    
    // allows me to save, delete and create. Need it to move notes to folders
    @Environment(\.modelContext) private var modelContext
    @Query private var folders: [Folder]
    
    @State private var selectedNote: Note?
    @State private var showingFolderPicker = false
    
    let notes: [Note]
    @State private var showingNewNote = false
    @State private var searchText: String = ""
    
    var filteredNotes: [Note] {
        guard !searchText.isEmpty else { return notes }
        return notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        Group {
            if notes.isEmpty {
                VStack {
                    Text("No Thoughts Yet")
                        .foregroundStyle(.secondary)
                    Button(action: { showingNewNote = true }) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            } else {
                List(filteredNotes) { note in
                    NavigationLink(destination: NoteEditView(note: note)) {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                modelContext.delete(note)
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .tint(.red)
                            }
                            Button {
                                selectedNote = note
                                showingFolderPicker = true
                            } label: {
                                Label("Move to Folder", systemImage: "folder")
                            }
                        }
                        .sheet(isPresented: $showingFolderPicker) {
                            NavigationStack {
                                List(folders) { folder in
                                    Button(action: {
                                        selectedNote?.folder = folder
                                        showingFolderPicker = false
                                    }) {
                                        HStack {
                                            Text(folder.name)
                                            Spacer()
                                            if selectedNote?.folder?.id == folder.id {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                                .navigationTitle("Select Folder")
                                .toolbar {
                                    Button("Cancel") {
                                        showingFolderPicker = false
                                    }
                                }
                            }
                            .presentationDetents([.medium])
                        }
                      
                    }
                   
                }
                .searchable(text: $searchText, prompt: "Search thoughts...")
                
            }
        }
        .navigationTitle("Thoughts 💭")
        
        .toolbar {
            Button(action: { showingNewNote = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingNewNote) {
            NavigationStack {
                NoteEditView()
            }
        }
    }
}

#Preview {
    ContentView()
}
