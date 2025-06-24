import Fluent
import Vapor

struct AccountController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let account = routes.grouped("account")

        account.get(use: self.index)
//        account.post(use: self.create)
        account.group("sign-up") { _account in
            _account.get(use: self.signup)
        }
        account.group("login") { _account in
            _account.get(use: self.login)
        }
    }

    @Sendable
    func index(req: Request) async throws -> Response {
        req.redirect(to: "/account/sign-up")
    }
    
    @Sendable
    func signup(req: Request) async throws -> View {
        try await req.view.render("signup", ["title": TitleService.getTitle(title: "Sign Up")])
    }
    
    @Sendable
    func login(req: Request) async throws -> View {
        try await req.view.render("login", ["title": TitleService.getTitle(title: "Login")])
    }

//    @Sendable
//    func create(req: Request) async throws -> TodoDTO {
//        let todo = try req.content.decode(TodoDTO.self).toModel()
//
//        try await todo.save(on: req.db)
//        return todo.toDTO()
//    }
}
