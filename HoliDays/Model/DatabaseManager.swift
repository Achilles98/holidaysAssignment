
import Foundation
import SQLite3

class DatabaseManager{
    var db: OpaquePointer?
    var path = "myDb.sqlite"
    init() {
        self.db = createDB()
    }
    
    //Creating or opening the local sqlite database
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        db = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            return nil
        }else{
            return db
        }
    }
    
    //Creating a table to save the holidays information
    func createTable(){
        let query = "CREATE TABLE IF NOT EXISTS holidays(name TEXT, date TEXT, year TEXT, PRIMARY KEY(name, year));"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Success")
            }else{
                print("Fail")
            }
        }else{
            print("Preperation fail")
        }
    }
    
    //Inserting the holidays information to the table we created
    func insert(_ year : String,_ name : String,_ date : String) {
            let query = "INSERT INTO holidays (name, date, year) VALUES (?, ?, ?);"
            
            var statement : OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                
                sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (date as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (year as NSString).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Data inserted success")
                }else {
                    print("Data is not inserted in table")
                }
            } else {
              print("Query is not as per requirement")
            }
            
        }
    
    //Reading and finding if information of the holidays exist. 
    func read(_ year : String) -> [HolidaysData] {
        var result: [HolidaysData] = []
            
            let query = "SELECT * FROM holidays WHERE year = (?);"
            var statement : OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                sqlite3_bind_text(statement, 1, (year as NSString).utf8String, -1, nil)
                while sqlite3_step(statement) == SQLITE_ROW {
                    let name = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                    let date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    let holiday: HolidaysData = HolidaysData.init(date: date, name: name)
                    result.append(holiday)
                }
            }
            return result
        }
        
}
