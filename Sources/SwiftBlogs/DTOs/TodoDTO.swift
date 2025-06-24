import Fluent
import Vapor

struct TodoDTO: Content {
    var id: UUID?
    var title: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    func toModel() -> Todo {
        let model = Todo()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
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
