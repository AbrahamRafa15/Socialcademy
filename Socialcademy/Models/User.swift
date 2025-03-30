//
//  User.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 20/03/25.
//

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
    
    
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}


