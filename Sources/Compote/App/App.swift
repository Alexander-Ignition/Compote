import ArgumentParser
import NIO
import NIOHTTP1
import Logging

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

        var logger = Logger(label: "Compote")
        logger.logLevel = options.logLevel

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
