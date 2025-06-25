import Fluent
import Vapor

struct AccountController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let account = routes.grouped("account")

        account.get(use: self.index)

        account.group("sign-up") { _account in
            _account.get(use: self.signup)
            _account.post(use: self.createAccount)
        }
        account.group("login") { _account in
            _account.get(use: self.login)
            let credentialsProtectedRoute = _account.grouped(User.credentialsAuthenticator())
            credentialsProtectedRoute.post(use: self.loginUser)
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

    @Sendable
    func createAccount(req: Request) async throws -> Response {
        try User.Create.validate(content: req)
        let createUser = try req.content.decode(User.Create.self)
        
        guard createUser.password == createUser.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        
        let userService = UserService(db: req.db)
        try await userService.createUser(createUser: createUser)
        return req.redirect(to: "/")
    }

    @Sendable
    func loginUser(req: Request) async throws -> Response {
        return req.redirect(to: "/")
    }
}
