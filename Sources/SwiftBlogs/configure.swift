import Fluent
import FluentMySQLDriver
import Leaf
import LeafKit
import Vapor
import Foundation

public func configure(_ app: Application) async throws {
    // Configure Leaf with two sources:
    //   1. The consumer's app views directory (highest priority — overrides bundled templates)
    //   2. Bundled SwiftBlogs templates (fallback — admin area, auth pages)
    // SPM bundles resources at the bundle root (strips the "Resources/" prefix from .copy() paths)
    let bundledViewsPath = Bundle.module.resourcePath! + "/Views"
    let sources = LeafSources()
    let appViewsPath = app.directory.viewsDirectory
    if FileManager.default.fileExists(atPath: appViewsPath) {
        try sources.register(
            source: "app",
            using: NIOLeafFiles(
                fileio: app.fileio,
                limits: .default,
                sandboxDirectory: appViewsPath,
                viewDirectory: appViewsPath
            ),
            searchable: true
        )
    }
    try sources.register(
        source: "bundled",
        using: NIOLeafFiles(
            fileio: app.fileio,
            limits: .default,
            sandboxDirectory: bundledViewsPath,
            viewDirectory: bundledViewsPath
        ),
        searchable: true
    )
    app.leaf.sources = sources
    app.views.use(.leaf)

    // Serve static files: consumer's Public/ directory first, bundled SwiftBlogs assets as fallback.
    // Bundled assets are namespaced under /swiftblogs/ to avoid URL conflicts.
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    let bundledPublicPath = Bundle.module.resourcePath! + "/Public"
    app.middleware.use(FileMiddleware(publicDirectory: bundledPublicPath))

    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "swiftblogs",
        password: Environment.get("DATABASE_PASSWORD") ?? "swiftblogs",
        database: Environment.get("DATABASE_NAME") ?? "swiftblogs"
    ), as: .mysql)

    app.sessions.use(.fluent)
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(User.sessionAuthenticator())

    app.migrations.add(SessionRecord.migration)
    app.migrations.add(CreateUser())

    app.asyncCommands.use(CreateUserCommand(), as: "create-user")

    try routes(app)
}
