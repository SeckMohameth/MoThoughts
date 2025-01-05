import Foundation
import SwiftData

@Model
class Note {
    @Attribute(.unique) var id: UUID
    
    //Basic note properties
    var title: String
    var content: String
    var createdAt: Date
    var lastModifiedDate: Date
    


    
    // can be nil
    var folder: Folder? // Relationship to Folder

    
    //Initializer to create a new note
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.lastModifiedDate = Date()
        



    }
}

// Folder Model
@Model
class Folder {
    // Unique identifier for each folder
    @Attribute(.unique) var id: UUID
    
    //Folder name
    var name: String
    
    // Add createdAt for folders too
    var createdAt: Date

    
    // Relationship to Note objects
    // @Relationship tells SwiftData this is a two-way relationship
    // inverse: \Note.folder means it connects to the folder property in Note
    @Relationship(inverse: \Note.folder) var notes: [Note]?
    
    //create new folder
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.notes = [] // initialize with empty notes array
    }
}
