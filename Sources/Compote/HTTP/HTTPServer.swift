import NIO
import NIOHTTP1
import Logging

final class HTTPServer {
    private let bootstrap: ServerBootstrap
    private let logger: Logger
    private let routeHandler: RouteHanlder

    init(group: EventLoopGroup, logger: Logger, routeHandler: @escaping RouteHanlder) {
        self.bootstrap = ServerBootstrap(group: group)
        self.logger = logger
        self.routeHandler = routeHandler
    }

    func run(host: String, port: Int) throws {
        let bootstrap = self.bootstrap
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
                    let handler = HTTPHandler(logger: self.logger, routeHandler: self.routeHandler)
                    return channel.pipeline.addHandler(handler)
                }
            }
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)

        let channel = try bootstrap.bind(host: host, port: port).wait()

        guard let localAddress = channel.localAddress else {
            fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
        }
        logger.info("Server started and listening on \(localAddress)")

        // This will never unblock as we don't close the ServerChannel
        try channel.closeFuture.wait()

        logger.info("Server closed")
    }

}

final class HTTPHandler: ChannelInboundHandler {
    private let logger: Logger

    /// HTTP request handler.
    private let routeHandler: RouteHanlder

    /// Incoming HTTP request.
    private var request: HTTPRequest!

    init(logger: Logger, routeHandler: @escaping RouteHanlder) {
        self.logger = logger
        self.routeHandler = routeHandler
    }

    // MARK: - ChannelInboundHandler

    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        switch unwrapInboundIn(data) {
        case .head(let head):
            assert(request == nil)
            let capacity = head.headers.first(name: "Content-Lenght").flatMap { Int($0) }
            let body = capacity.map { context.channel.allocator.buffer(capacity: $0) }
            request = HTTPRequest(head: head, body: body)
        case .body(var buffer):
            assert(request != nil)
            if request.body == nil {
                request.body = buffer
            } else {
                request.body!.writeBuffer(&buffer)
            }
        case .end(let headers):
            assert(headers == nil)
            let routeContext = RouteContext(
                logger: Logger(label: "tofo"),
                eventLoop: context.eventLoop,
                allocator: context.channel.allocator,
                request: request)
            request = nil
            do {
                let future = try routeHandler(routeContext)
                future.whenFailure { context.fireErrorCaught($0) }
                future.whenSuccess { self.writeResponse($0, context: context) }
            } catch let error as HTTPError {
                let response = HTTPResponse(status: error.status)
                writeResponse(response, context: context)
            } catch {
                let response = HTTPResponse(status: .internalServerError)
                writeResponse(response, context: context)
            }
        }
    }

    // MARK: - Private

    private func writeResponse(_ response: HTTPResponse, context: ChannelHandlerContext) {
        let head = HTTPResponseHead(
            version: HTTPVersion(major: 1, minor: 1),
            status: response.status,
            headers: response.headers)

        logger.debug("\(response)")

        switch response.body {
        case .none:
            writeHead(head, context: context)
        case .byteBuffer(let byteBuffer)?:
            writeBuffer(byteBuffer, head: head, context: context)
        case .fileRegion(let fileRegion)?:
            writeFileRegion(fileRegion, head: head, context: context)
        }
    }

    private func writeHead(_ head: HTTPResponseHead, context: ChannelHandlerContext) {
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }

    private func writeBuffer(_ buffer: ByteBuffer, head: HTTPResponseHead, context: ChannelHandlerContext) {
        context.write(wrapOutboundOut(.head(head)), promise: nil)
        context.write(wrapOutboundOut(.body(IOData.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }

    private func writeFileRegion(_ fileRegion: FileRegion, head: HTTPResponseHead, context: ChannelHandlerContext) {
        context.write(self.wrapOutboundOut(.head(head)), promise: nil)
        context.writeAndFlush(self.wrapOutboundOut(.body(.fileRegion(fileRegion))))
            .flatMap { context.writeAndFlush(self.wrapOutboundOut(.end(nil))) }
            .whenComplete { _ in try! fileRegion.fileHandle.close() }
    }

}
