//
//  UserService.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 24.06.25.
//

import Fluent

struct UserService {
    var db: any Database
    
    func createUser(userDTO: UserDTO) async throws -> Void {
        let user = userDTO.toModel()
        // TODO: hash the password before saving it!
        try await user.save(on: self.db)
    }
}
