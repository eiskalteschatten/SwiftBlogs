import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("status", .string, .required)
            .field("role", .string, .required)
            .field("verification_code", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .unique(on: "email")
            .unique(on: "verification_code")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
