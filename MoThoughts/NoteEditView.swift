import SwiftUI
import SwiftData

struct NoteEditView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var note: Note?
    @State private var title = ""
    @State private var content = ""
    
    // MARK: - Initialization
    init(note: Note? = nil) {
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Title Field
            TextField("Title", text: $title)
                .font(.title2)
                .padding()
                .background(Color(uiColor: .systemBackground))
            
            Divider()
            
            // Content Field
            TextEditor(text: $content)
                .font(.body)
                .padding(.horizontal)
            
            // Toolbar
            HStack {
                Button(action: addBulletPoint) {
                    Image(systemName: "list.bullet")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    saveNote()
                }
                .disabled(title.isEmpty)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func addBulletPoint() {
        content.append("\n• ")
    }
    
    private func saveNote() {
        if let existingNote = note {
            // Update existing note
            existingNote.title = title
            existingNote.content = content
            existingNote.lastModifiedDate = Date()
        } else {
            // Create new note
            let newNote = Note(title: title, content: content)
            modelContext.insert(newNote)
        }
        dismiss()
    }
}

// End of file. No additional code.
