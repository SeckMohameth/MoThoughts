import SwiftUI
import SwiftData

struct FolderView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var folders: [Folder]
    @State private var showingNewFolder = false
    @State private var newFolderName = ""
    
    @State private var searchText: String = ""
    @State private var filteredFolders: [Folder] = []
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(searchText.isEmpty ? folders : filteredFolders) { folder in
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
        .searchable(text: $searchText, prompt: "Search folders...")
        .onChange(of: searchText) { _, newValue in
            if !newValue.isEmpty {
                filteredFolders = folders.filter { folder in
                    folder.name.localizedCaseInsensitiveContains(newValue)
                }
            } else {
                filteredFolders = folders
            }
        }
        .navigationTitle("Folders ")
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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let folder: Folder
    @State private var showingRenameDialog = false
    @State private var newFolderName = ""
    
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
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    if let notes = folder.notes,
                       let index = notes.firstIndex(where: { $0.id == note.id }) {
                        note.folder = nil
                    }
                } label: {
                    Label("Remove", systemImage: "folder.badge.minus")
                }
            }
        }
        .navigationTitle(folder.name)
        .toolbar {
            Menu {
                Button {
                    newFolderName = folder.name
                    showingRenameDialog = true
                } label: {
                    Label("Rename Folder", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    modelContext.delete(folder)
                    dismiss()
                } label: {
                    Label("Delete Folder", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .alert("Rename Folder", isPresented: $showingRenameDialog) {
            TextField("Folder Name", text: $newFolderName)
            Button("Cancel", role: .cancel) { }
            Button("Rename") {
                folder.name = newFolderName
            }
        } message: {
            Text("Enter a new name for this folder")
        }
    }
}

#Preview {
    FolderView()
}
