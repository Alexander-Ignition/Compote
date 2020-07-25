import NIOHTTP1

public struct HTTPError: Error {
    public var status: HTTPResponseStatus

    public init(status: HTTPResponseStatus) {
        self.status = status
    }
}
