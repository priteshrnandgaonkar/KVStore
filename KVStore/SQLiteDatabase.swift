//
//  SQLiteDatabase.swift
//  KVStore
//
//  Created by Pritesh Nandgaonkar on 8/2/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation

/// This error enum takes care of all the error cases which might occur in the sqlite operations
public enum SQLiteError: Error {
    
    /// This error occurs while opening the database connection
    case openDatabase(message: String)
    
    /// This error occurs while preparing the SQLite statement
    case prepare(message: String)
    
    /// This error occurs while steping the SQLite statement
    case step(message: String)
    
    /// This error occurs while binding the SQLite statement with data
    case bind(message: String)
    
    /// This error occurs while querying the data for key, but key doesnt exist
    case query(message: String)
}

extension SQLiteError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .openDatabase(let message):
            return message
        case .prepare(let message):
            return message
        case .step(let message):
            return message
        case .bind(let message):
            return message
        case .query(let message):
            return message
        }
    }
}

final class SQLiteDatabase {
    private let dbPointer: OpaquePointer
    
    private init(dbPointer: OpaquePointer) {
        self.dbPointer = dbPointer
    }
    
    private var errorMessage: String {
        if let errorMessage = String(validatingUTF8: sqlite3_errmsg(dbPointer)) {
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
                
        var db: OpaquePointer? = nil
        // SQLite in serialized threaded mode
        if sqlite3_open_v2(path, &db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db!)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            
            if let message = String(validatingUTF8: sqlite3_errmsg(db)) {
                throw SQLiteError.openDatabase(message: message)
            } else {
                throw SQLiteError.openDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    func prepareStatement(sql: String) throws -> OpaquePointer {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
        
        return statement!
    }
    
    func createTable(table: SQLTable.Type) throws {
        
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
        print("\(table) table created.")
    }
    
    func insert(model: RowModel) throws {
        
        let isThereKey = checkIfIdExistIn(tableName: RowModel.tableName, id: model.id)
        
        if isThereKey {
            try update(model: model)
            return
        }
        
        let insertSql = "INSERT INTO \(RowModel.tableName) (Id, Data) VALUES (?, ?);"
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        
        let blobData = model.data as NSData
        let bytes = blobData.bytes
        
        guard sqlite3_bind_int64(insertStatement, 1, sqlite3_int64(model.id)) == SQLITE_OK  &&
            sqlite3_bind_blob(insertStatement, 2, bytes, Int32(blobData.length), nil) == SQLITE_OK else {
                throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
        
    }
    
    func update(model: RowModel) throws {
        
        let isThereKey = checkIfIdExistIn(tableName: RowModel.tableName, id: model.id)
        
        if !isThereKey {
            throw SQLiteError.query(message: "Tried to update \(model.id), but it doesnt exist")
        }
        
        let updateSql = "UPDATE \(RowModel.tableName) SET Data = ? WHERE Id = \(model.id);"
        let updateStatement = try prepareStatement(sql: updateSql)
        //\(model.id)
        defer {
            sqlite3_finalize(updateStatement)
        }
        
        let blobData = model.data as NSData
        let bytes = blobData.bytes
        
        guard sqlite3_bind_blob(updateStatement, 1, bytes, Int32(blobData.length), nil) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_step(updateStatement) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
    }
    
    func getValue(for key: Int, tableName: String) throws -> Data {
        
        let isThereKey = checkIfIdExistIn(tableName: RowModel.tableName, id: key)
        
        if !isThereKey {
            throw SQLiteError.query(message: "Tried to fetch \(key), but it doesnt exist")
        }
        
        
        let getQuery = "SELECT Data FROM \(tableName) WHERE Id = '\((key))'"
        let getStatement = try prepareStatement(sql: getQuery)
        
        defer {
            sqlite3_finalize(getStatement)
        }
        
        if sqlite3_step(getStatement) == SQLITE_ROW {
            let bytes = sqlite3_column_bytes(getStatement, 0)
            return Data(bytes: sqlite3_column_blob(getStatement, 0), count: Int(bytes))
            
        } else {
            print("Could not Get Data for a key")
            throw SQLiteError.step(message: errorMessage)
        }
    }

    func delete(key: Int) throws {
        
        let isThereKey = checkIfIdExistIn(tableName: RowModel.tableName, id: key)
        
        if !isThereKey {
            throw SQLiteError.query(message: "Tried to delete \(key), but it doesnt exist")
        }
        
        let deleteSql = "DELETE FROM \(RowModel.tableName) WHERE Id = \(key);"
        let deleteStatement = try prepareStatement(sql: deleteSql)
        
        defer {
            sqlite3_finalize(deleteStatement)
        }
        
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("Successfully deleted row.")
        } else {
            print("Could not delete row.")
            throw SQLiteError.step(message: errorMessage)
        }
    }

    func checkIfIdExistIn(tableName: String, id: Int) -> Bool {
        
        let idQuery = "SELECT * FROM \(tableName) WHERE Id='\(id)'"
        
        do {
            let idQueryStatement = try prepareStatement(sql: idQuery)
            defer {
                sqlite3_finalize(idQueryStatement)
            }
            
            if sqlite3_step(idQueryStatement) == SQLITE_ROW {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func checkIfTableExist(table type: SQLTable.Type) -> Bool {
        
        let tableQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name='\(type.tableName)'"
        
        do {
            let tableExistStatement = try prepareStatement(sql: tableQuery)
            defer {
                sqlite3_finalize(tableExistStatement)
            }
            
            if sqlite3_step(tableExistStatement) == SQLITE_ROW {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
