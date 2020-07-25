import NIO
import NIOHTTP1
import Logging
import Foundation

public typealias RouteHanlder = (RouteContext) throws -> EventLoopFuture<HTTPResponse>

public struct RouteContext {
    public var uuid: UUID
    public var logger: Logger
    public var eventLoop: EventLoop

    /// Response body memory allocator.
    public var allocator: ByteBufferAllocator

    /// Original HTTP request.
    public var request: HTTPRequest

    /// Matched route parameters.
    public var parameters: [String: String] = [:]

    public var path: [String] = []

    public init(
        uuid: UUID = UUID(),
        logger: Logger,
        eventLoop: EventLoop,
        allocator: ByteBufferAllocator,
        request: HTTPRequest,
        parameters: [String: String] = [:]
    ) {
        self.uuid = uuid
        self.logger = logger
        self.logger[metadataKey: "request-id"] = .string(uuid.uuidString)
        self.eventLoop = eventLoop
        self.allocator = allocator
        self.path = Array(URL(string: request.head.uri)!.pathComponents.dropFirst())
        self.request = request
        self.parameters = parameters
    }
}

extension RouteContext {

    public func parameter(_ name: String) throws -> String {
        if let value = parameters[name] {
            return value
        }
        throw HTTPError(status: .badRequest)
    }

    public func response(
        status: HTTPResponseStatus = .ok,
        headers: HTTPHeaders = [:],
        body: ResponseBody? = nil
    ) -> EventLoopFuture<HTTPResponse> {
        response(status, headers, body: body?.build(allocator))
    }

    public func response(
        _ status: HTTPResponseStatus = .ok,
        _ headers: HTTPHeaders = [:],
        body: IOData?
    ) -> EventLoopFuture<HTTPResponse> {

        if !status.mayHaveResponseBody, body != nil {
            logger.warning("\(status) has unexpected body")
        }

        let response = HTTPResponse(
            status: status,
            headers: headers,
            body: body)

        return eventLoop.makeSucceededFuture(response)
    }
}

public struct ResponseBody {
    @usableFromInline
    let build: (ByteBufferAllocator) -> IOData

    @inlinable
    public init(build: @escaping (ByteBufferAllocator) -> IOData) {
        self.build = build
    }

    @inlinable
    public static func string(_ string: String) -> ResponseBody {
        ResponseBody { IOData.byteBuffer($0.buffer(string: string)) }
    }
}
