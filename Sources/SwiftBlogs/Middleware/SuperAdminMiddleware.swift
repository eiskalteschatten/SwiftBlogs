import Vapor

struct SuperAdminMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let user = request.auth.get(User.self) else {
            return request.redirect(to: "/account/login")
        }
        guard user.role == .superAdmin else {
            throw Abort(.forbidden, reason: "You do not have permission to access this resource.")
        }
        return try await next.respond(to: request)
    }
}
