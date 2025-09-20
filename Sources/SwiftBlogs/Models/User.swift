import Fluent
import Vapor
import struct Foundation.UUID
import struct Foundation.Date

enum UserStatus: String, Codable {
    case active = "active",
        disabled = "disabled",
        unverified = "unverified"
}

enum UserRole: String, Codable {
    case user = "user",
        superAdmin = "super_admin"
}

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class User: Model, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Enum(key: "status")
    var status: UserStatus
    
    @Enum(key: "role")
    var role: UserRole
    
    @Field(key: "verification_code")
    var verificationCode: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, name: String, email: String, password: String, status: UserStatus = .unverified, role: UserRole = .user, verificationCode: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.status = status
        self.role = role
        self.verificationCode = verificationCode
    }
    
    func toDTO() -> UserDTO {
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
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: ModelSessionAuthenticatable { }

extension User: ModelCredentialsAuthenticatable {
    static let usernameKey: KeyPath<User, FieldProperty<User, String>> = \User.$email
    static let passwordHashKey: KeyPath<User, FieldProperty<User, String>> = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}