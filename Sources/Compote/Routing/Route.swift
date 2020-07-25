public protocol Route {
    associatedtype Body: Route
    var route: Body { get }
}

extension Never: Route {
    public var route: Never { fatalError() }
}
