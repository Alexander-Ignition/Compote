import NIO
import NIOHTTP1

/// HTTP response.
public struct HTTPResponse {

    /// A HTTP response status code.
    public var status: HTTPResponseStatus

    /// A HTTP response status header fields.
    public var headers: HTTPHeaders

    /// HTTP response body.
    public var body: IOData?

    /// A new HTTP response.
    public init(
        status: HTTPResponseStatus,
        headers: HTTPHeaders = [:],
        body: IOData? = nil
    ) {
        self.status = status
        self.headers = headers
        self.body = body
    }

    /// The number of body bytes.
    public var count: Int {
        switch body {
        case .none:
            return 0
        case .byteBuffer(let buffer)?:
            return buffer.readableBytes
        case .fileRegion(let fileRegion)?:
            return fileRegion.endIndex
        }
    }

    /// Add missing headers.
    mutating func normalize() {
        if body != nil, !headers.contains(name: "Content-Length") {
            headers.add(name: "Content-Length", value: "\(count)")
        }
//        response.headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
    }
}
