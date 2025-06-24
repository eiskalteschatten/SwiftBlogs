import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": TitleService.getTitle()])
    }

    app.get("sign-up") { req async throws in
        try await req.view.render("signup", ["title": TitleService.getTitle(title: "Sign Up")])
    }
    
    app.get("login") { req async throws in
        try await req.view.render("login", ["title": TitleService.getTitle(title: "Login")])
    }

//    try app.register(collection: TodoController())
}
