import Fluent
import Vapor

public struct UserDTO: Content {
    public var id: UUID?
    public var name: String?
    public var email: String?
    public var status: UserStatus?
    public var role: UserRole?
    public var createdAt: Date?
    public var updatedAt: Date?

    public init(id: UUID? = nil, name: String? = nil, email: String? = nil, status: UserStatus? = nil, role: UserRole? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.status = status
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public func toModel() -> User {
        let model = User()
        
        model.id = self.id
        if let name = self.name {
            model.name = name
        }
        if let email = self.email {
            model.email = email
        }
        if let status = self.status {
            model.status = status
        }
        if let role = self.role {
            model.role = role
        }
        if let createdAt = self.createdAt {
            model.createdAt = createdAt
        }
        if let updatedAt = self.updatedAt {
            model.updatedAt = updatedAt
        }
        return model
    }
}
