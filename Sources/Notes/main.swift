import ArgumentParser
import Compote

struct NoteRoutes: Route {
    var route: some Route {
        Router("notes") {
            GET()
            GET(":id")
            POST()
        }
    }
}

struct UserRoutes: Route {
    var route: some Route {
        Router("users") {
            GET {
                $0.response(body: .string("all users"))
            }
            GET(":id") {
                let id = try $0.parameter("id")
                return $0.response(body: .string("user by \(id)"))
            }
            POST {
                $0.response(status: .created, body: .string("new user"))
            }
            DELETE {
                $0.response(status: .noContent, body: .string("none"))
            }
        }
    }
}

struct NotesApp: App {
    @OptionGroup()
    var options: LaunchOptions

    @RouteBuilder
    var route: some Route {
        GET { (context) -> EventLoopFuture<HTTPResponse> in
            context.response(body: .string("Hello"))
        }
        UserRoutes()
        NoteRoutes()
    }
}

NotesApp.main()
