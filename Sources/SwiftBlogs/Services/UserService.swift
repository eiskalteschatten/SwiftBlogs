//
//  UserService.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 24.06.25.
//

import Fluent
import Vapor

public struct UserService {
    public var db: any Database

    public init(db: any Database) {
        self.db = db
    }

    public func createUser(createUser: User.Create) async throws -> Void {
        guard try await User.query(on: self.db).filter(\.$email == createUser.email).first() == nil else {
            throw Abort(.conflict, reason: "A user with that email already exists.")
        }
        
        let user = try User(
            name: createUser.name,
            email: createUser.email,
            password: Bcrypt.hash(createUser.password),
            status: .active
        )
        
        try await user.save(on: self.db)
    }
}
