import Foundation
import SQLite3

struct Note {
    var id: Int32
    var content: String
    var noteCategory = "All"
}

class NoteManager {
    var database: OpaquePointer?
    
    static let shared = NoteManager()
    
    private init() {
    }
    
    func connect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("notes.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS notes (
                content TEXT,
                noteCategory TEXT
            )
            """,
            nil,
            nil,
            nil
        ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }

    }
    
    func create() -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO notes (content, noteCategory) VALUES ('Write a note!', 'All')",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting note")
            }
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getNotes() -> [Note] {
        connect()
        
        var result: [Note] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, content, noteCategory FROM notes", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Note(
                    id: sqlite3_column_int(statement, 0),
                    content: String(cString: sqlite3_column_text(statement, 1)),
                    noteCategory: String(cString: sqlite3_column_text(statement, 2))
                ))
            }
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func saveNote(note: Note) {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "UPDATE notes SET content = ?, noteCategory = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: note.content).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: note.noteCategory).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, note.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving note")
            }
        }
        else {
            print("Error creating note update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteNote(note: Note) {
        connect()
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, note.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting note")
            }
        }
    }
}
