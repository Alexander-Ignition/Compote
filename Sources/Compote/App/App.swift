import ArgumentParser
import NIO
import NIOHTTP1
import Logging

extension Logger.Level: ExpressibleByArgument {}

public struct LaunchOptions: ParsableArguments {
    @Argument(help: "A hostname which should be resolved.")
    public var host: String = "::1"

    @Argument(help: "A port the server will run on.")
    public var port: Int = 8888

    /// Default launch options.
    public init() {}
}

/// Web application.
public protocol App: Route, ParsableCommand {
    /* @OptionGroup */
    var options: LaunchOptions { get }

    init()
}

extension App {
    public func run() throws {
        let router = RouteBuilder.buildBlock(route)
        print(router)

        let logger = Logger(label: "Compote")
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer {
            try! group.syncShutdownGracefully()
        }

        let server = HTTPServer(
            group: group,
            logger: logger,
            routeHandler: router.response)

        try server.run(host: options.host, port: options.port)
    }
}
