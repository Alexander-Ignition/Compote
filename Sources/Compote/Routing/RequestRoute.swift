import NIO
import NIOHTTP1

public typealias RequestRouteHanlder = (RouteContext) throws -> EventLoopFuture<HTTPResponse>

public func notImplemented(_ context: RouteContext) -> EventLoopFuture<HTTPResponse> {
    context.response(status: .notImplemented)
}

public struct RequestRoute: Route {
    public var route: Never { fatalError() }

    public let method: NIOHTTP1.HTTPMethod
    public var path: PathPattern
    public let handler: RequestRouteHanlder

    public init(
        _ method: NIOHTTP1.HTTPMethod,
        _ path: PathPattern = .init(),
        handler: @escaping RequestRouteHanlder = notImplemented
    ) {
        self.method = method
        self.path = path
        self.handler = handler
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

// MARK: - HTTP method

public struct GET: Route {
    private let path: PathPattern
    private let handler: RequestRouteHanlder

    public init(
        _ path: PathPattern = .init(),
        handler: @escaping RequestRouteHanlder = notImplemented
    ) {
        self.path = path
        self.handler = handler
    }

    public var route: some Route {
        RequestRoute(.GET, path, handler: handler)
    }
}

public struct POST: Route {
    private let path: PathPattern
    private let handler: RequestRouteHanlder

    public init(
        _ path: PathPattern = .init(),
        handler: @escaping RequestRouteHanlder = notImplemented
    ) {
        self.path = path
        self.handler = handler
    }

    public var route: some Route {
        RequestRoute(.POST, path, handler: handler)
    }
}

public struct PUT: Route {
    private let path: PathPattern
    private let handler: RequestRouteHanlder

    public init(
        _ path: PathPattern = .init(),
        handler: @escaping RequestRouteHanlder = notImplemented
    ) {
        self.path = path
        self.handler = handler
    }

    public var route: some Route {
        RequestRoute(.PUT, path, handler: handler)
    }
}

public struct PATCH: Route {
    private let path: PathPattern
    private let handler: RequestRouteHanlder

    public init(
        _ path: PathPattern = .init(),
        handler: @escaping RequestRouteHanlder = notImplemented
    ) {
        self.path = path
        self.handler = handler
    }

    public var route: some Route {
        RequestRoute(.PATCH, path, handler: handler)
    }
}

public struct DELETE: Route {
    private let path: PathPattern
    private let handler: RequestRouteHanlder

    public init(
        _ path: PathPattern = .init(),
        handler: @escaping RequestRouteHanlder = notImplemented
    ) {
        self.path = path
        self.handler = handler
    }

    public var route: some Route {
        RequestRoute(.DELETE, path, handler: handler)
    }
}
