//
//  RowModel.swift
//  KVStore
//
//  Created by Pritesh Nandgaonkar on 8/2/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation

protocol SQLTable {
    static var createStatement: String { get }
    static var tableName: String { get }
}

public struct RowModel {
    let id: Int
    let data: Data
}

extension RowModel: Equatable {
    public static func ==(lhs: RowModel, rhs: RowModel) -> Bool {
        return (lhs.id == rhs.id) && (lhs.data == rhs.data)
    }
}

extension RowModel: SQLTable {
    static var tableName = "KVPersistence"
    
    static var createStatement: String {
        return "CREATE TABLE \(RowModel.tableName)(" +
            "Id INT PRIMARY KEY NOT NULL," +
            "Data BLOB," + "UNIQUE(Id)" +
        ");"
    }
}
