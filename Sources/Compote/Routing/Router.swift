import NIO
import NIOHTTP1

public struct Router: Route {
    public var route: Never { fatalError() }

    private var routes: [RequestRoute] = []

    /// Empty router.
    public init() {}

    public init(
        _ path: PathPattern? = nil,
        @RouteBuilder routes: () -> Router
    ) {
        var contents = routes().routes
        if let path = path {
            for (index, route) in contents.enumerated() {
                contents[index].path = path.appending(route.path)
            }
        }
        self.routes = contents
    }
}

extension Router {
    func response(_ context: RouteContext) throws -> EventLoopFuture<HTTPResponse> {
        var context = context
        for route in routes where route.match(&context) {
            return try route.handler(context)
        }
        throw HTTPError(status: .notFound)
    }
}

// MARK: - CustomStringConvertible

extension Router: CustomStringConvertible {
    public var description: String {
        routes.map { "- \($0)" } .joined(separator: "\n")
    }
}

// MARK: - Append

extension Router {
    mutating func append(_ route: RequestRoute) {
        routes.append(route)
    }

    mutating func append(_ router: Router) {
        routes.append(contentsOf: router.routes)
    }

    mutating func append<T>(_ route: T) where T: Route {
        switch route {
        case let router as Router:
            append(router)
        case let one as RequestRoute:
            append(one)
        default:
            append(route.route)
        }
    }
}
