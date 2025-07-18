//
//  UserService.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 24.06.25.
//

import Fluent
import Vapor

struct UserService {
    var db: any Database
    
    func createUser(createUser: User.Create) async throws -> Void {
        let user = try User(
            name: createUser.name,
            email: createUser.email,
            password: Bcrypt.hash(createUser.password),
            verificationCode: [UInt8].random(count: 32).base64
        )
        
        try await user.save(on: self.db)
    }
}
