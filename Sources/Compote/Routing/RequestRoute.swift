import NIO
import NIOHTTP1

@inlinable
public func GET(_ path: PathPattern = .init(), handler: RouteHanlder? = nil) -> RequestRoute {
    RequestRoute(.GET, path, handler: handler)
}

@inlinable
public func POST(_ path: PathPattern = .init(), handler: RouteHanlder? = nil) -> RequestRoute {
    RequestRoute(.POST, path, handler: handler)
}

@inlinable
public func PUT(_ path: PathPattern = .init(), handler: RouteHanlder? = nil) -> RequestRoute {
    RequestRoute(.PUT, path, handler: handler)
}

@inlinable
public func PATCH(_ path: PathPattern = .init(), handler: RouteHanlder? = nil) -> RequestRoute {
    RequestRoute(.PATCH, path, handler: handler)
}

@inlinable
public func DELETE(_ path: PathPattern = .init(), handler: RouteHanlder? = nil) -> RequestRoute {
    RequestRoute(.DELETE, path, handler: handler)
}

// MARK: - Basic

public struct RequestRoute: Route {
    public var route: Never { fatalError() }

    public let method: NIOHTTP1.HTTPMethod
    public var path: PathPattern
    public let handler: RouteHanlder

    public init(
        _ method: NIOHTTP1.HTTPMethod,
        _ path: PathPattern = .init(),
        handler: RouteHanlder?
    ) {
        self.method = method
        self.path = path
        self.handler = handler ?? Self.notImplemented
    }

    private static let notImplemented: RouteHanlder = {
        $0.response(status: .notImplemented)
    }

    func match(_ context: inout RouteContext) -> Bool {
        guard context.request.head.method == method else {
            return false
        }
        guard let parameters = path.match(from: context.path) else {
            return false
        }
        context.parameters = parameters
        return true
    }
}

// MARK: - CustomStringConvertible

extension RequestRoute: CustomStringConvertible {
    public var description: String {
        "\(method) \(path)"
    }
}

