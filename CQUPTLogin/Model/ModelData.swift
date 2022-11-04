//
//  ModelData.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/3.
//

import Foundation

var documentUrl = URL(filePath: NSHomeDirectory().appending("/Documents/"))
var fileManager = FileManager.default


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    do {
        data = try Data(contentsOf: documentUrl.appending(path: filename))
    } catch {
        fatalError("Couldn't load \(filename) under \(documentUrl.absoluteString)!")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Decode error!")
    }
}

func save(_ user: User, _ filename: String) {
    let data: Data
    
    do {
        let encoder = JSONEncoder()
        data = try encoder.encode(user)
        try data.write(to: documentUrl.appending(path: filename))
    } catch {
        fatalError("Encode and Write error!")
    }
}
