import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

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

    app.views.use(.leaf)
    
    app.asyncCommands.use(CreateUserCommand(), as: "create-user")

    // register routes
    try routes(app)
}
