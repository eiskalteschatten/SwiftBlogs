import Fluent
import Vapor

struct UserDTO: Content {
    var id: UUID?
    var username: String?
    var email: String?
    var password: String?
    var status: UserStatus?
    var role: UserRole?
    var verificationCode: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    func toModel() -> User {
        let model = User()
        
        model.id = self.id
        if let username = self.username {
            model.username = username
        }
        if let email = self.email {
            model.email = email
        }
        if let password = self.password {
            model.password = password
        }
        if let status = self.status {
            model.status = status
        }
        if let role = self.role {
            model.role = role
        }
        if let verificationCode = self.verificationCode {
            model.verificationCode = verificationCode
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
