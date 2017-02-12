//
//  KVStoreManager.swift
//  KVStore
//
//  Created by Pritesh Nandgaonkar on 9/2/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation

protocol CRUDDelegate {
    func insert<T: Hashable>(value: Data, for key: T) throws
    func deleteValue<T: Hashable>(for key: T) throws
    func update<T: Hashable>(value: Data, for key: T) throws
    func getValue<T: Hashable>(for key: T) throws -> Data
}

public class KVStoreManager: CRUDDelegate {
    
    let db: SQLiteDatabase
    
    public init(with fileName: String) throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docPath = paths[0]
        db = try SQLiteDatabase.open(path: docPath + "/" + "\(fileName).sqlite")
        if !db.checkIfTableExist(table: RowModel.self) {
            try db.createTable(table: RowModel.self)
        }
        print("Successfully opened connection to database.")
    }
        
    public func insert<T: Hashable>(value: Data, for key: T) throws {
        let model = RowModel(id: (key.hashValue) , data: value)
        try db.insert(model: model)
        
    }
    
    public func deleteValue<T: Hashable>(for key: T) throws {
        try db.delete(key: key.hashValue)
    }
    
    public func update<T: Hashable>(value: Data, for key: T) throws {
        try db.update(model:  RowModel(id: (key.hashValue) , data: value))
    }
    
    public func getValue<T: Hashable>(for key: T) throws -> Data {
        return try db.getValue(for: key.hashValue, tableName: RowModel.tableName)
    }
}
