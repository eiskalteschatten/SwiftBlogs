//
//  MakeSuperAdminCommand.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 02/06/2026.
//

import Fluent
import Vapor

struct MakeSuperAdminCommand: AsyncCommand {
    struct Signature: CommandSignature {
        @Argument(name: "email", help: "The email address of the user to promote to super admin.")
        var email: String
    }

    var help: String {
        "Promotes a user to the super_admin role by their email address."
    }

    func run(using context: CommandContext, signature: Signature) async throws {
        let db = context.application.db

        guard let user = try await User.query(on: db)
            .filter(\.$email == signature.email)
            .first()
        else {
            context.console.error("No user found with email: \(signature.email)")
            return
        }

        user.role = .superAdmin
        try await user.save(on: db)

        context.console.success("User '\(user.name)' (\(user.email)) has been promoted to super_admin.")
    }
}
