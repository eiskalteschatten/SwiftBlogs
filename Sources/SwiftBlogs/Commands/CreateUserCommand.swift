//
//  CreateUserCommand.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 02/06/2026.
//

import Fluent
import Vapor

public struct CreateUserCommand: AsyncCommand {
    public struct Signature: CommandSignature {
        public init() {}
    }

    public init() {}

    public var help: String {
        "Creates a user."
    }

    public func run(using context: CommandContext, signature: Signature) async throws {
        let name = context.console.ask("Name:")
        let email = context.console.ask("Email:")
        let password = context.console.ask("Password: ", isSecure: true)
        let confirmPassword = context.console.ask("Confirm password: ", isSecure: true)

        guard password == confirmPassword else {
            context.console.error("Passwords do not match.")
            return
        }

        guard password.count >= 8 else {
            context.console.error("Password must be at least 8 characters.")
            return
        }

        let db = context.application.db
        let userService = UserService(db: db)
        let createUser = User.Create(name: name, email: email, password: password)

        do {
            try await userService.createUser(createUser: createUser)
            context.console.success("User '\(name)' (\(email)) has been created.")
        } catch let abort as Abort {
            context.console.error(abort.reason)
        }
    }
}
