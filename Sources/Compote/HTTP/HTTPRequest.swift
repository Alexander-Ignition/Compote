import NIO
import NIOHTTP1

/// HTTP request.
public struct HTTPRequest {
    /// Method, URI and headers.
    public var head: HTTPRequestHead

    /// Request body.
    public var body: ByteBuffer?

    /// A new HTTP request.
    ///
    /// - Parameters:
    ///   - head: Method, URI and headers.
    ///   - body: Request body.
    public init(head: HTTPRequestHead, body: ByteBuffer? = nil) {
        self.head = head
        self.body = body
    }
}
