import ArgumentParser
import Logging

public struct LaunchOptions: ParsableArguments {
    @Option(help: "A hostname which should be resolved.")
    public var host: String = "::1"

    @Option(help: "A port the server will run on.")
    public var port: Int = 8888

    @Option(help: "A log level.")
    public var logLevel: Logger.Level = .info

    /// Default launch options.
    public init() {}
}

extension Logger.Level: ExpressibleByArgument {}
