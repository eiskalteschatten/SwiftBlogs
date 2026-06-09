import Fluent

public struct CreateUser: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("status", .string, .required)
            .field("role", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .unique(on: "email")
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
