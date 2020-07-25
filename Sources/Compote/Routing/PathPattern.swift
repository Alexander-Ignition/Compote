/// `PathPattern`
///
/// Represent of `/api/notes/:id`
public struct PathPattern: Hashable, Codable {
    /// Parameter name prefix.
    public static let parameterPrefix = ":"

    /// Path components.
    ///
    ///     ["api", "notes", ":id"]
    public var components: [String]

    /// Empty path.
    public init() {
        components = []
    }

    /// A new path from components.
    ///
    /// - Parameter components: path components.
    public init(components: [String]) {
        self.components = components
    }
}

extension PathPattern {
    func appending(_ path: PathPattern) -> PathPattern {
        var copy = self
        copy.components.append(contentsOf: path.components)
        return copy
    }

    public func match(from pathComponents: [String]) -> [String: String]? {
        guard components.count == pathComponents.count else {
            return nil
        }
        var parameters: [String: String] = [:]
        for (key, value) in zip(components, pathComponents) {
            if key.hasPrefix(Self.parameterPrefix) {
                parameters[String(key.dropFirst())] = String(value)
            } else if key != value {
                return nil
            }
        }
        return parameters
    }
}

// MARK: - CustomStringConvertible

extension PathPattern: CustomStringConvertible {
    public var description: String {
        if components.isEmpty {
            return "/"
        } else {
            return components.joined(separator: "/")
        }
    }
}

// MARK: - LosslessStringConvertible

extension PathPattern: LosslessStringConvertible {
    public init(_ description: String) {
        components = description.split(separator: "/").map { String($0) }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension PathPattern: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        components = elements
    }
}

// MARK: - ExpressibleByStringLiteral

extension PathPattern: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
