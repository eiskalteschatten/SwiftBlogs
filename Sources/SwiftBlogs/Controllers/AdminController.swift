//
//  AdminController.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 02/06/2026.
//

import Fluent
import Vapor

struct AdminController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let admin = routes
            .grouped(User.sessionAuthenticator())
            .grouped(SuperAdminMiddleware())
            .grouped("admin")

        admin.get(use: self.index)
    }

    @Sendable
    func index(req: Request) async throws -> View {
        let user = req.auth.get(User.self)
        let username = user?.name ?? nil
        return try await req.view.render("admin/index", ["title": TitleService.getTitle("Admin"), "username": username])
    }
}
