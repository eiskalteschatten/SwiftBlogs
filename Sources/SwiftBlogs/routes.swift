import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws -> View in   
        let user = req.auth.get(User.self)
        let username = user?.name ?? nil
        return try await req.view.render("index", ["title": TitleService.getTitle(), "username": username])
    }

    try app.register(collection: AccountController())
}
