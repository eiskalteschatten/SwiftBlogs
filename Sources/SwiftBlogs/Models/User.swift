import Fluent
import Vapor
import struct Foundation.UUID
import struct Foundation.Date

public enum UserStatus: String, Codable, Sendable {
    case active = "active",
        disabled = "disabled",
        unverified = "unverified"
}

public enum UserRole: String, Codable, Sendable {
    case user = "user",
        superAdmin = "super_admin"
}

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
public final class User: Model, @unchecked Sendable {
    public static let schema = "users"
    
    @ID(key: .id)
    public var id: UUID?

    @Field(key: "name")
    public var name: String

    @Field(key: "email")
    public var email: String

    @Field(key: "password")
    public var password: String

    @Enum(key: "status")
    public var status: UserStatus

    @Enum(key: "role")
    public var role: UserRole

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?

    public init() { }

    public init(id: UUID? = nil, name: String, email: String, password: String, status: UserStatus = .unverified, role: UserRole = .user) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.status = status
        self.role = role
    }
    
    public func toDTO() -> UserDTO {
        .init(
            id: self.id,
            name: self.$name.value,
            email: self.$email.value,
            status: self.$status.value,
            role: self.$role.value,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}

extension User {
    public struct Create: Content {
        public var name: String
        public var email: String
        public var password: String
        public var confirmPassword: String?

        public init(name: String, email: String, password: String, confirmPassword: String? = nil) {
            self.name = name
            self.email = email
            self.password = password
            self.confirmPassword = confirmPassword
        }
    }
}

extension User.Create: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: ModelSessionAuthenticatable { }

extension User: ModelCredentialsAuthenticatable {
    public static let usernameKey: KeyPath<User, FieldProperty<User, String>> = \User.$email
    public static let passwordHashKey: KeyPath<User, FieldProperty<User, String>> = \User.$password

    public func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
