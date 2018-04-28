import Foundation

public final class Application {

    // NOTE: this is covered by a test case
    let message = "STS: Hello, world!"

    public init() {

    }

    public func run() throws {
        print(message)
    }
}