import SwiftUI
import SwiftData

struct FolderView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var folders: [Folder]
    @State private var showingNewFolder = false
    @State private var newFolderName = ""
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(folders) { folder in
                    NavigationLink(destination: FolderDetailView(folder: folder)) {
                        VStack {
                            Image(systemName: "folder.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.blue)
                            Text(folder.name)
                                .foregroundStyle(.primary)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Folders")
        .toolbar {
            Button(action: { showingNewFolder = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingNewFolder) {
            NavigationStack {
                Form {
                    TextField("Folder Name", text: $newFolderName)
                }
                .navigationTitle("New Folder")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingNewFolder = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create") {
                            let newFolder = Folder(name: newFolderName)
                            modelContext.insert(newFolder)
                            newFolderName = ""
                            showingNewFolder = false
                        }
                        .disabled(newFolderName.isEmpty)
                    }
                }
            }
            .presentationDetents([.height(200)])
        }
    }
}

// MARK: - FolderDetailView
struct FolderDetailView: View {
    let folder: Folder
    
    var body: some View {
        List(folder.notes ?? []) { note in
            NavigationLink(destination: NoteEditView(note: note)) {
                VStack(alignment: .leading) {
                    Text(note.title)
                        .font(.headline)
                    Text(note.content)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(folder.name)
    }
}

